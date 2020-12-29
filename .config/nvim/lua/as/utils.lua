local M = {}
local fn = vim.fn

function M.total_plugins()
  local base_path = fn.stdpath("data") .. "/site/pack/packer/"
  local start = vim.split(fn.globpath(base_path .. "start", "*"), "\n")
  local opt = vim.split(fn.globpath(base_path .. "opt", "*"), "\n")
  local start_count = vim.tbl_count(start)
  local opt_count = vim.tbl_count(opt)
  return {total = start_count + opt_count, start = start_count, lazy = opt_count}
end

M.plugins_count = M.total_plugins()

-- https://stackoverflow.com/questions/1283388/lua-merge-tables
function M.deep_merge(t1, t2)
  for k, v in pairs(t2) do
    if (type(v) == "table") and (type(t1[k] or false) == "table") then
      M.deep_merge(t1[k], t2[k])
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
function M.profile(filename)
  local base = "/tmp/config/profile/"
  fn.mkdir(base, "p")
  local success, profile = pcall(require, "plenary.profile.lua_profiler")
  if not success then
    return vim.cmd [[echomsg "Plenary is not installed."]]
  end
  profile.start()
  return function()
    profile.stop()
    local logfile = base .. filename .. ".log"
    profile.report(logfile)
    vim.defer_fn(
      function()
        vim.cmd("tabedit " .. logfile)
      end,
      1000
    )
  end
end

function M.map(mode, lhs, rhs, opts)
  opts = opts or {noremap = true, silent = true}
  vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
end

function M.plugin_loaded(name)
  return vim.fn.PluginLoaded(name) > 0
end

return M