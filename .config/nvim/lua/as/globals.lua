local fn = vim.fn
local api = vim.api
local fmt = string.format
-----------------------------------------------------------------------------//
-- Global namespace
-----------------------------------------------------------------------------//
--- Inspired by @tjdevries' astraunauta.nvim/ @TimUntersberger's config
--- store all callbacks in one global table so they are able to survive re-requiring this file
_G.__as_global_callbacks = __as_global_callbacks or {}

_G.as = {
  _store = __as_global_callbacks,
}

-----------------------------------------------------------------------------//
-- UI
-----------------------------------------------------------------------------//
-- Consistent store of various UI items to reuse throughout my config
as.style = {
  icons = {
    error = '✗',
    warning = '',
    info = '',
    hint = '',
  },
  palette = {
    pale_red = '#E06C75',
    dark_red = '#be5046',
    light_red = '#c43e1f',
    dark_orange = '#FF922B',
    green = '#98c379',
    bright_yellow = '#FAB005',
    light_yellow = '#e5c07b',
    dark_blue = '#4e88ff',
    magenta = '#c678dd',
    comment_grey = '#5c6370',
    grey = '#3E4556',
    whitesmoke = '#626262',
    bright_blue = '#51afef',
    teal = '#15AABF',
  },
}

-----------------------------------------------------------------------------//
-- Messaging
-----------------------------------------------------------------------------//

if vim.notify then
  ---Override of vim.notify to open floating window
  --@param message of the notification to show to the user
  --@param log_level Optional log level
  --@param opts Dictionary with optional options (timeout, etc)
  vim.notify = function(message, log_level, _)
    assert(message, 'The message key of vim.notify should be a string')
    as.notify(message, { timeout = 5000, log_level = log_level })
  end
end

-----------------------------------------------------------------------------//
-- Debugging
-----------------------------------------------------------------------------//
if pcall(require, 'plenary') then
  RELOAD = require('plenary.reload').reload_module

  R = function(name)
    RELOAD(name)
    return require(name)
  end
end

-- inspect the contents of an object very quickly
-- in your code or from the command-line:
-- USAGE:
-- in lua: dump({1, 2, 3})
-- in commandline: :lua dump(vim.loop)
---@vararg any
function P(...)
  local objects = vim.tbl_map(vim.inspect, { ... })
  print(unpack(objects))
end

local installed
---Check if a plugin is on the system not whether or not it is loaded
---@param plugin_name string
---@return boolean
function as.plugin_installed(plugin_name)
  if not installed then
    local dirs = fn.expand(fn.stdpath 'data' .. '/site/pack/packer/start/*', true, true)
    local opt = fn.expand(fn.stdpath 'data' .. '/site/pack/packer/opt/*', true, true)
    vim.list_extend(dirs, opt)
    installed = vim.tbl_map(function(path)
      return fn.fnamemodify(path, ':t')
    end, dirs)
  end
  return vim.tbl_contains(installed, plugin_name)
end

---NOTE: this plugin returns the currently loaded state of a plugin given
---given certain assumptions i.e. it will only be true if the plugin has been
---loaded e.g. lazy loading will return false
---@param plugin_name string
---@return boolean?
function _G.plugin_loaded(plugin_name)
  local plugins = packer_plugins or {}
  return plugins[plugin_name] and plugins[plugin_name].loaded
end
-----------------------------------------------------------------------------//
-- Utils
-----------------------------------------------------------------------------//
function as._create(f)
  table.insert(as._store, f)
  return #as._store
end

function as._execute(id, args)
  as._store[id](args)
end

---@class Autocommand
---@field events string[] list of autocommand events
---@field targets string[] list of autocommand patterns
---@field modifiers string[] e.g. nested, once
---@field command string | function

---Create an autocommand
---@param name string
---@param commands Autocommand[]
function as.augroup(name, commands)
  vim.cmd('augroup ' .. name)
  vim.cmd 'autocmd!'
  for _, c in ipairs(commands) do
    local command = c.command
    if type(command) == 'function' then
      local fn_id = as._create(command)
      command = fmt('lua as._execute(%s)', fn_id)
    end
    vim.cmd(
      string.format(
        'autocmd %s %s %s %s',
        table.concat(c.events, ','),
        table.concat(c.targets or {}, ','),
        table.concat(c.modifiers or {}, ' '),
        command
      )
    )
  end
  vim.cmd 'augroup END'
end

---Check if a cmd is executable
---@param e string
---@return boolean
function as.executable(e)
  return fn.executable(e) > 0
end

---Echo a msg to the commandline
---@param msg string | table
---@param hl string
function as.echomsg(msg, hl)
  hl = hl or 'Title'
  local msg_type = type(msg)
  assert(
    msg_type ~= 'string' or msg_type ~= 'table',
    fmt('message should be a string or list of strings not a %s', msg_type)
  )
  if msg_type == 'string' then
    msg = { { msg, hl } }
  end
  vim.api.nvim_echo(msg, true, {})
end

-- https://stackoverflow.com/questions/1283388/lua-merge-tables
function as.deep_merge(t1, t2)
  for k, v in pairs(t2) do
    if (type(v) == 'table') and (type(t1[k] or false) == 'table') then
      as.deep_merge(t1[k], t2[k])
    else
      t1[k] = v
    end
  end
  return t1
end

--- Usage:
--- 1. Call `local stop = utils.profile('my-log')` at the top of the file
--- 2. At the bottom of the file call `stop()`
--- 3. Restart neovim, the newly created log file should open
function as.profile(filename)
  local base = '/tmp/config/profile/'
  fn.mkdir(base, 'p')
  local success, profile = pcall(require, 'plenary.profile.lua_profiler')
  if not success then
    vim.api.nvim_echo({ 'Plenary is not installed.', 'Title' }, true, {})
  end
  profile.start()
  return function()
    profile.stop()
    local logfile = base .. filename .. '.log'
    profile.report(logfile)
    vim.defer_fn(function()
      vim.cmd('tabedit ' .. logfile)
    end, 1000)
  end
end

---check if a certain feature/version/commit exists in nvim
---@param feature string
---@return boolean
function as.has(feature)
  return vim.fn.has(feature) > 0
end

---Check if directory exists using vim's isdirectory function
---@param path string
---@return boolean
function as.is_dir(path)
  return fn.isdirectory(path) > 0
end

---Check if a vim variable usually a number is truthy or not
---@param value integer
function as.truthy(value)
  assert(type(value) == 'number', fmt('Value should be a number but you passed %s', value))
  return value > 0
end

---Find an item in a list
---@generic T
---@param haystack T[]
---@param matcher fun(arg: T):boolean
---@return T
function as.find(haystack, matcher)
  local found
  for _, needle in ipairs(haystack) do
    if matcher(needle) then
      found = needle
      break
    end
  end
  return found
end

---Determine if a value of any type is empty
---@param item any
---@return boolean
function as.empty(item)
  if not item then
    return true
  end
  local item_type = type(item)
  if item_type == 'string' then
    return item == ''
  elseif item_type == 'table' then
    return vim.tbl_isempty(item)
  end
end

---check if a mapping already exists
---@param lhs string
---@param mode string
---@return boolean
function as.has_map(lhs, mode)
  mode = mode or 'n'
  return vim.fn.maparg(lhs, mode) ~= ''
end

local function validate_opts(opts)
  if not opts then
    return true
  end

  if type(opts) ~= 'table' then
    return false, 'opts should be a table'
  end

  if opts.buffer and type(opts.buffer) ~= 'number' then
    return false, 'The buffer key should be a number'
  end

  return true
end

local function validate_mappings(lhs, rhs, opts)
  vim.validate {
    lhs = { lhs, 'string' },
    rhs = {
      rhs,
      function(a)
        local arg_type = type(a)
        return arg_type == 'string' or arg_type == 'function'
      end,
      'right hand side',
    },
    opts = { opts, validate_opts, 'mapping options are incorrect' },
  }
end

---create a mapping function factory
---@param mode string
---@param o table
---@return fun(lhs: string, rhs: string, opts: table|nil) 'create a mapping'
local function make_mapper(mode, o)
  -- copy the opts table as extends will mutate the opts table passed in otherwise
  local parent_opts = vim.deepcopy(o)
  ---Create a mapping
  ---@param lhs string
  ---@param rhs string|function
  ---@param opts table
  return function(lhs, rhs, opts)
    assert(lhs ~= mode, fmt('The lhs should not be the same as mode for %s', lhs))
    local _opts = opts and vim.deepcopy(opts) or {}

    validate_mappings(lhs, rhs, _opts)

    if _opts.check_existing and as.has_map(lhs, mode) then
      return
    else
      -- don't pass this invalid key to set keymap
      _opts.check_existing = nil
    end

    -- add functions to a global table keyed by their index
    if type(rhs) == 'function' then
      local fn_id = as._create(rhs)
      rhs = string.format('<cmd>lua as._execute(%s)<CR>', fn_id)
    end

    if _opts.buffer then
      -- Remove the buffer from the args sent to the key map function
      local bufnr = _opts.buffer
      _opts.buffer = nil
      _opts = vim.tbl_extend('keep', _opts, parent_opts)
      api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, _opts)
    else
      api.nvim_set_keymap(mode, lhs, rhs, vim.tbl_extend('keep', _opts, parent_opts))
    end
  end
end

local map_opts = { noremap = false, silent = true }
local noremap_opts = { noremap = true, silent = true }

as.nmap = make_mapper('n', map_opts)
as.xmap = make_mapper('x', map_opts)
as.imap = make_mapper('i', map_opts)
as.vmap = make_mapper('v', map_opts)
as.omap = make_mapper('o', map_opts)
as.tmap = make_mapper('t', map_opts)
as.smap = make_mapper('s', map_opts)
as.cmap = make_mapper('c', { noremap = false, silent = false })

as.nnoremap = make_mapper('n', noremap_opts)
as.xnoremap = make_mapper('x', noremap_opts)
as.vnoremap = make_mapper('v', noremap_opts)
as.inoremap = make_mapper('i', noremap_opts)
as.onoremap = make_mapper('o', noremap_opts)
as.tnoremap = make_mapper('t', noremap_opts)
as.snoremap = make_mapper('s', noremap_opts)
as.cnoremap = make_mapper('c', { noremap = true, silent = false })

---Create an nvim command
---@param args table
function as.command(args)
  local nargs = args.nargs or 0
  local name = args[1]
  local rhs = args[2]
  local types = (args.types and type(args.types) == 'table') and table.concat(args.types, ' ') or ''

  if type(rhs) == 'function' then
    local fn_id = as._create(rhs)
    rhs = string.format('lua as._execute(%d%s)', fn_id, nargs > 0 and ', <f-args>' or '')
  end

  vim.cmd(string.format('command! -nargs=%s %s %s %s', nargs, types, name, rhs))
end

function as.invalidate(path, recursive)
  if recursive then
    for key, value in pairs(package.loaded) do
      if key ~= '_G' and value and vim.fn.match(key, path) ~= -1 then
        package.loaded[key] = nil
        require(key)
      end
    end
  else
    package.loaded[path] = nil
    require(path)
  end
end

local function get_last_notification()
  for _, win in ipairs(api.nvim_list_wins()) do
    local buf = api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == 'vim-notify' and api.nvim_win_is_valid(win) then
      return api.nvim_win_get_config(win)
    end
  end
end

local notification_hl = setmetatable({
  [2] = { 'FloatBorder:NvimNotificationError', 'NormalFloat:NvimNotificationError' },
  [1] = { 'FloatBorder:NvimNotificationInfo', 'NormalFloat:NvimNotificationInfo' },
}, {
  __index = function(t, k)
    local is_number = type(k) == 'number'
    k = is_number and k or 2 -- handle incorrect level keys as errors
    if not is_number then
      as.echomsg(fmt('%s is not a valid vim.notify error level', k), 'ErrorMsg')
    end
    return k > 1 and t[2] or t[1]
  end,
})

---Utility function to create a notification message
---@param lines string[] | string
---@param opts table
function as.notify(lines, opts)
  lines = type(lines) == 'string' and { lines } or lines
  lines = vim.tbl_flatten(vim.tbl_map(function(line)
    return vim.split(line, '\n')
  end, lines))
  opts = opts or {}
  local highlights = { 'NormalFloat:Normal' }
  local level = opts.log_level or 1
  local timeout = opts.timeout or 5000

  local width
  for i, line in ipairs(lines) do
    line = '  ' .. line .. '  '
    lines[i] = line
    local length = #line
    if not width or width < length then
      width = length
    end
  end
  local buf = api.nvim_create_buf(false, true)
  api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  local height = #lines
  local prev = get_last_notification()
  local row = prev and prev.row[false] - prev.height - 2 or vim.o.lines - vim.o.cmdheight - 3
  local win = api.nvim_open_win(buf, false, {
    relative = 'editor',
    width = width + 2,
    height = height,
    col = vim.o.columns - 2,
    row = row,
    anchor = 'SE',
    style = 'minimal',
    focusable = false,
    border = 'rounded',
  })

  local level_hl = notification_hl[level]

  vim.list_extend(highlights, level_hl)
  vim.wo[win].winhighlight = table.concat(highlights, ',')

  vim.bo[buf].filetype = 'vim-notify'
  vim.wo[win].wrap = true
  if timeout then
    vim.defer_fn(function()
      if api.nvim_win_is_valid(win) then
        api.nvim_win_close(win, true)
      end
    end, timeout)
  end
end
