--- =====================================================================
--- Resources:
--- =====================================================================
--- 1. https://gabri.me/blog/diy-vim-statusline
--- 2. https://github.com/elenapan/dotfiles/blob/master/config/nvim/statusline.vim
--- 3. https://got-ravings.blogspot.com/2008/08/vim-pr0n-making-statuslines-that-own.html
--- 4. Right sided truncation - https://stackoverflow.com/questions/20899651/how-to-truncate-a-vim-statusline-field-from-the-right

local utils = require "statusline/utils"
local P = require "statusline/palette"

local M = {}

local st_warning = {color = "StWarning", sep_color = "StWarningSep"}

M.git_updates = utils.git_updates
M.git_toggle_updates = utils.git_update_toggle

--- NOTE: Unicode characters including vim devicons should NOT be highlighted
--- as italic or bold, this is because the underlying bold font is not necessarily
--- patched with the nerd font characters
--- terminal emulators like kitty handle this by fetching nerd fonts elsewhere
--- but this is not universal across terminals so should be avoided
function M.colors()
  local normal_bg = utils.get_hl_color("Normal", "bg")
  local normal_fg = utils.get_hl_color("Normal", "fg")
  local pmenu_bg = utils.get_hl_color("Pmenu", "bg")
  local string_fg = utils.get_hl_color("String", "fg")
  local error_fg = utils.get_hl_color("ErrorMsg", "fg")
  local comment_fg = utils.get_hl_color("Comment", "fg")
  local warning_fg =
    vim.g.colors_name == "one" and P.light_yellow or
    utils.get_hl_color("WarningMsg", "fg")

  local highlights = {
    {"StMetadata", {guifg = comment_fg, gui = "italic,bold"}},
    {"StMetadataPrefix", {guifg = comment_fg}},
    {"StModified", {guifg = string_fg, guibg = pmenu_bg}},
    {"StPrefix", {guibg = pmenu_bg, guifg = normal_fg}},
    {"StPrefixSep", {guibg = normal_bg, guifg = pmenu_bg}},
    {"StDirectory", {guibg = normal_bg, guifg = "Gray", gui = "italic"}},
    {
      "StFilename",
      {guibg = normal_bg, guifg = "LightGray", gui = "italic,bold"}
    },
    {
      "StFilenameInactive",
      {guifg = P.comment_grey, guibg = normal_bg, gui = "italic,bold"}
    },
    {"StItem", {guibg = normal_fg, guifg = normal_bg, gui = "italic"}},
    {"StSep", {guifg = normal_fg}},
    {"StInfo", {guifg = P.dark_blue, guibg = normal_bg, gui = "bold"}},
    {"StInfoSep", {guifg = pmenu_bg}},
    {"StInactive", {guifg = normal_bg, guibg = P.comment_grey}},
    {"StInactiveSep", {guifg = P.comment_grey}},
    {"StatusLine", {guibg = normal_bg}},
    {"StatusLineNC", {guibg = normal_bg}},
    {"StWarning", {guifg = warning_fg, guibg = pmenu_bg}},
    {"StWarningSep", {guifg = pmenu_bg, guibg = normal_bg}},
    {"StError", {guifg = error_fg, guibg = pmenu_bg}},
    {"StErrorSep", {guifg = pmenu_bg, guibg = normal_bg}}
  }

  for _, hl in ipairs(highlights) do
    utils.set_highlight(unpack(hl))
  end
end

--- @param tbl table
--- @param next string
--- @param priority table
local function append(tbl, next, priority)
  priority = priority or 0
  local component, length = unpack(next)
  if component and component ~= "" and next and tbl then
    table.insert(
      tbl,
      {component = component, priority = priority, length = length}
    )
  end
end

local function add_min_width(item, minwid, trunc_amount)
  if not item or item == "" then
    return item
  end
  return "%" .. minwid .. "." .. trunc_amount .. "(" .. item .. "%)"
end

--- @param statusline table
--- @param available_space number
local function display(statusline, available_space)
  local str = ""
  local items = utils.prioritize(statusline, available_space)
  for _, item in ipairs(items) do
    if type(item.component) == "string" then
      str = str .. item.component
    end
  end
  return str
end

function _G.statusline()
  -- use the statusline global variable which is set inside of statusline
  -- functions to the window for *that* statusline
  local curwin = vim.g.statusline_winid or 0
  local curbuf = vim.api.nvim_win_get_buf(curwin)

  -- TODO reduce the available space whenever we add
  -- a component so we can use it to determine what to add
  local available_space = vim.fn.winwidth(curwin)

  local ctx = {
    bufnum = curbuf,
    winid = curwin,
    bufname = vim.fn.bufname(curbuf),
    preview = vim.wo[curwin].previewwindow,
    readonly = vim.bo[curbuf].readonly,
    filetype = vim.bo[curbuf].ft,
    buftype = vim.bo[curbuf].bt,
    modified = vim.bo[curbuf].modified,
    fileformat = vim.bo[curbuf].fileformat,
    shiftwidth = vim.bo[curbuf].shiftwidth,
    expandtab = vim.bo[curbuf].expandtab
  }
  ----------------------------------------------------------------------------//
  -- Modifiers
  ----------------------------------------------------------------------------//
  local plain = utils.is_plain(ctx)

  local current_mode = utils.mode()
  local file_modified = utils.modified(ctx, "●")
  local inactive = vim.api.nvim_get_current_win() ~= curwin
  local focused = vim.g.vim_in_focus or true
  local minimal = plain or inactive or not focused

  ----------------------------------------------------------------------------//
  -- Setup
  ----------------------------------------------------------------------------//
  local statusline = {}
  append(statusline, utils.spacer(1))

  ----------------------------------------------------------------------------//
  -- Filename
  ----------------------------------------------------------------------------//
  -- The filename component should be 20% of the screen width but has a minimum
  -- width of 10 since smaller than that is likely to be unintelligible
  -- although if the window is plain i.e. terminal or tree buffer allow the file
  -- name to take up more space
  local percentage = plain and 0.4 or 0.5
  local minwid = 5

  -- Don't set a minimum width for plain status line filenames
  local trunc_amount = math.ceil(available_space * percentage)

  -- highlight the filename component separately
  local filename_hl = minimal and "StFilenameInactive" or "StFilename"
  local directory_hl = minimal and "StInactiveSep" or "StDirectory"

  local directory, filename = utils.filename(ctx)
  local ft_icon, icon_highlight = utils.filetype(ctx)

  local opts = {prefix = ft_icon, before = "", after = ""}
  local file_opts = {before = "", after = ""}

  if not minimal then
    opts.prefix_color = icon_highlight
  end

  if not directory or directory == "" then
    file_opts.prefix = ft_icon
    if not minimal then
      file_opts.prefix_color = icon_highlight
    end
  end

  directory = add_min_width(directory, minwid, trunc_amount)
  local dir_item = utils.item(directory, directory_hl, opts)
  local file_item = utils.item(filename, filename_hl, file_opts)

  ----------------------------------------------------------------------------//
  -- Mode
  ----------------------------------------------------------------------------//
  -- show a minimal statusline with only the mode and file component
  if minimal then
    append(statusline, dir_item, 1)
    append(statusline, file_item, 0)
    return display(statusline, available_space)
  end

  append(statusline, utils.item(current_mode, "StModeText"), 0)

  append(statusline, dir_item, 1)
  append(statusline, file_item, 0)

  append(
    statusline,
    utils.sep_if(
      file_modified,
      ctx.modified,
      {
        small = 1,
        color = "StModified",
        sep_color = "StPrefixSep"
      }
    ),
    1
  )

  -- If local plugins are loaded and I'm developing locally show an indicator
  local develop_text = available_space > 100 and "local dev" or ""
  append(
    statusline,
    utils.sep_if(
      develop_text,
      vim.env.DEVELOPING,
      vim.tbl_extend(
        "keep",
        {
          prefix = " ",
          padding = "none",
          prefix_color = "StWarning",
          small = 1
        },
        st_warning
      )
    ),
    2
  )

  -- Neovim allows unlimited alignment sections so we can put things in the
  -- middle of our statusline - https://neovim.io/doc/user/vim_diff.html#vim-differences
  -- local statusline .= '%='

  -- Start of the right side layout
  append(statusline, {"%="})

  -- Current line number/total line number,  alternatives 
  append(
    statusline,
    utils.line_info({prefix = "ℓ", prefix_color = "StMetadataPrefix"}),
    4
  )

  -- Git Status
  local prefix, git_status = utils.git_status()
  append(statusline, utils.item(git_status, "StInfo", {prefix = prefix}), 1)

  local updates = vim.g.git_statusline_updates or {}
  local ahead = updates.ahead and tonumber(updates.ahead) or 0
  local behind = updates.behind and tonumber(updates.behind) or 0
  append(
    statusline,
    utils.item_if(
      ahead,
      ahead > 0,
      "StInfo",
      {prefix = "↑", after = behind > 0 and "" or " "}
    )
  )
  append(
    statusline,
    utils.item_if(behind, behind > 0, "StInfo", {prefix = "↓", after = " "})
  )

  -- LSP Diagnostics
  local info = utils.diagnostic_info()
  append(statusline, utils.item(info.error, "Error"), 1)
  append(statusline, utils.item(info.warning, "PreProc"), 2)
  append(statusline, utils.item(info.information, "String"), 3)

  -- LSP Status
  append(statusline, utils.item(utils.lsp_status(), "Comment"), 3)
  append(statusline, utils.item(utils.current_fn(), "StMetadata"), 4)

  -- Indentation
  local unexpected_indentation = ctx.shiftwidth > 2 or not ctx.expandtab
  append(
    statusline,
    utils.item_if(
      ctx.shiftwidth,
      unexpected_indentation,
      "Title",
      {prefix = ctx.expandtab and "Ξ" or "⇥", prefix_color = "PmenuSbar"}
    ),
    4
  )

  append(statusline, {"%<"})
  -- removes 5 columns to add some padding
  return display(statusline, available_space - 5)
end

local function setup_autocommands()
  vim.cmd [[augroup custom_statusline]]
  vim.cmd [[autocmd!]]
  vim.cmd [[autocmd FocusGained *  let g:vim_in_focus = v:true]]
  vim.cmd [[autocmd FocusLost * let g:vim_in_focus = v:false]]
  -- The quickfix window sets it's own statusline, so we override it here
  vim.cmd [[autocmd FileType qf setlocal statusline=%!v:lua.statusline()]]
  vim.cmd [[autocmd VimEnter,ColorScheme * lua require'statusline'.colors()]]
  vim.cmd [[autocmd VimEnter * lua require'statusline'.git_updates()]]
  vim.cmd [[autocmd DirChanged * lua require'statusline'.git_toggle_updates()]]
  vim.cmd [[augroup END]]
end

-- attach autocommands
setup_autocommands()

-- set the statusline
vim.o.statusline = "%!v:lua.statusline()"

return M
