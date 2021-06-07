local luv = vim.loop

local sep = "/"
local default_target = ".localrc.lua"

local M = {
  found_rc = nil
}

local function notify(msg, level, delay)
  vim.defer_fn(
    function()
      vim.notify(msg, level, delay)
    end,
    delay or 200
  )
end

function M.open()
  if M.found_rc then
    vim.cmd("vsplit " .. M.found_rc)
  else
    notify("No LocalRC found")
  end
end

local function get_parent(str)
  local parts = vim.split(str, "[/\\]")
  parts[#parts] = nil
  return table.concat(parts, sep)
end

local function setup_localrc(path)
  as.augroup(
    "LocalRC",
    {
      {
        events = {"BufWritePost"},
        target = {path},
        command = function()
          M.reload(path)
        end
      }
    }
  )
end

local function load_rc(path)
  local success, msg = pcall(dofile, path)
  if success then
    setup_localrc(path)
  end
  local message =
    success and "Successfully loaded " .. vim.fn.fnamemodify(path, ":~:.") or
    "Failed to load because: " .. msg
  notify(message)
end

function M.reload(path)
  vim.cmd("luafile " .. path)
  notify("Reloaded " .. path)
end

---@param path string|nil
---@param target string|nil
function M.load(path, target)
  path = path and #path > 0 and path or vim.fn.getcwd()
  target = target or default_target

  local found
  local is_home = path == os.getenv("HOME")
  if is_home then
    return
  end

  local dir, err = luv.fs_opendir(path)
  if not dir and err then
    notify("[Local init @ " .. path .. " failed]: " .. err, vim.log.levels.Error)
  end
  repeat
    local entry = luv.fs_readdir(dir)
    if entry then
      for _, item in ipairs(entry) do
        if item and item.name == target then
          found = item
          assert(luv.fs_closedir(dir), "unable to close directory " .. path)
        end
      end
    end
  until not entry or found
  if found then
    local rc_path = path .. sep .. found.name
    M.found_rc = rc_path
    load_rc(rc_path)
  elseif not is_home then
    M.load(get_parent(path), target)
  end
end

--- trigger loading of localrc
function M.setup()
  as.augroup(
    "LoadLocalInit",
    {
      {
        events = {"VimEnter"},
        targets = {"*"},
        command = [[lua require("as.localrc").load()]]
      }
    }
  )
  as.command {
    "LocalrcEdit",
    function()
      require("as.localrc").open()
    end
  }
end

return M
