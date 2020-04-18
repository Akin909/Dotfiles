if exists('g:gui_oni')
  finish
endif

let s:theme_opts = {
  \ 'one': { 'name': 'one', 'color': '#1b1e24' },
  \ 'onedark': { 'name': 'onedark', 'color': '#1b1e24' },
  \ 'palenight': { 'name': 'palenight', 'color': '' },
  \ 'tender': { 'name': 'tender', 'color': '#1d1d1d' },
  \ 'nightowl': { 'name': 'nightowl', 'color': '#060F1F' },
  \ 'vim-monokai-tasty': { 'name': 'monokai_tasty', 'color': '#1d1d1d' }
  \ }

function! s:get_active_theme() abort
  for [key, value] in items(s:theme_opts)
    if strlen(matchstr(key, g:colors_name))
      return value['name']
    endif
  endfor
  return ""
endfunction

let s:active_theme = s:get_active_theme()

augroup LightlineColorscheme
  autocmd!
  autocmd ColorScheme * call s:lightline_update()
augroup END

function! s:lightline_update()
  if !exists('g:loaded_lightline')
    return
  endif
  try
    " @TODO: Add a check here that the supported colorscheme is in our
    " s:theme_opts
    let g:lightline.colorscheme = s:get_active_theme()
    call s:custom_lightline_theme()
    call lightline#init()
    call lightline#colorscheme()
    call lightline#update()
  catch
  endtry
endfunction

let g:lightline = {
      \ 'colorscheme': s:active_theme,
      \ 'active': {
      \  'left':[['mode'], ['filename', 'filetype', 'filesize'], ['coc_git_repo']],
      \   'right': [
      \     ['coc_git_buffer'],
      \     ['coc_status'],
      \     ['current_function'],
      \     ['lineinfo'],
      \     ['csv']
      \]
      \ },
      \ 'inactive': {
      \   'left': [ [ 'filename'] ],
      \   'right': [ [] ]
      \ },
      \ 'component': {
      \   'lineinfo': '%3l:%-2L',
      \   'close': '%#LightLineClose#%999X ✗ ',
      \ },
      \ 'component_function': {
      \   'filesize': 'LightlineFileSize',
      \   'fugitive': 'LightlineFugitive',
      \   'filename': 'LightlineFilename',
      \   'fileformat': 'LightlineFileformat',
      \   'filetype': 'LightlineFiletype',
      \   'fileencoding': 'LightlineFileencoding',
      \   'csv':'LightlineCsv',
      \   'mode': 'LightlineMode',
      \   'autosave': 'LightlineAutosave',
      \   'gitgutter': 'LightlineGitGutter',
      \   'current_function': 'CocCurrentFunction',
      \   'coc_git_buffer': 'CocGitStatus',
      \   'coc_git_repo': 'CocGitRepoStatus',
      \    'coc_status': 'coc#status',
      \ },
      \ 'component_type': {
      \     'buffers': 'tabsel',
      \     'minimal_tabs': 'raw',
      \ },
      \ 'component_expand': {
      \     'buffers': 'lightline#bufferline#buffers',
      \     'minimal_tabs': 'LightlineMinimalTabs',
      \},
      \ 'component_visible_condition': {
      \   'readonly': '(&filetype!="help"&& &readonly)',
      \   'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
      \   'fugitive': '(exists("*fugitive#head") && ""!=fugitive#head())',
      \   'csv': '(exists("*CSV_WCol") && &ft =~ "csv")'
      \},
      \ 'component_raw': {
      \   'buffers': 1
      \},
      \ 'subseparator': { 'left': '', 'right': '' },
      \ 'tabline': {'left': [ [ 'buffers' ] ], 'right': [ [ 'minimal_tabs','close' ] ]}
      \ }

" ==============================
" Minial tab indicators
" ==============================
highlight MinimalTabActive guifg=dodgerblue guibg=white
call utils#extend_highlight('Normal', 'LightLineClose', 'gui=bold guifg=#E06C75')

function s:tab_window_count(n) abort
  let number_of_windows = tabpagewinnr(a:n, '$')
  let window_count = ""
  if number_of_windows > 0
    let window_count = "(" . number_of_windows . ")"
  endif
  return window_count
endfunction

function s:tab_label(n) abort
  try
    let buflist = tabpagebuflist(a:n)
    let winnr = tabpagewinnr(a:n)
    let full_path =  bufname(buflist[winnr - 1])
    if full_path == ""
      return "[No Name] "
    endif
    let truncated = fnamemodify(full_path, ":t")
    return truncated . " " . s:tab_window_count(a:n) . " "
  catch /.*/
    echom v:exception
    return ""
  endtry
endfunction

function! s:tab_renderer(tabnr, highlight) abort
  let component = ''

  let label = s:tab_label(a:tabnr)

  " select the highlighting
  let component .= a:tabnr == tabpagenr() ?
        \ '%#'. a:highlight .'#' : '%#TabLine#'
  " set the tab page number (for mouse clicks)
  let component .= '%' . a:tabnr . 'T'
  " add the label for the indicator
  let component .= ' ' . a:tabnr . '. '
  let component .= label
  " after the last tab fill with TabLineFill and reset tab page nr
  let component .= '%#TabLineFill#%T'
  return component
endfunction

function! CocCurrentFunction()
    return get(b:, 'coc_current_function', '')
endfunction

function CocGitStatus() abort
  let status = get(b:, "coc_git_status", "")
  return winwidth(0) > 120 ? status : ''
endfunction

function CocGitRepoStatus() abort
  return get(g:, "coc_git_status", "")
endfunction

function! LightlineMinimalTabs() abort
  let tabs = range(1, tabpagenr('$'))
  if len(tabs) < 2
    return ""
  endif
  return join(map(l:tabs, { -> s:tab_renderer(v:val, 'TabLineSel') }))
endfunction

""---------------------------------------------------------------------------//
"Lightline Bufferline
""---------------------------------------------------------------------------//
set showtabline=2

let g:lightline#bufferline#composed_number_map = {
  \ 0: '⁰', 1: '¹', 2: '²', 3: '³', 4: '⁴', 5: '⁵',
  \ 6: '⁶', 7: '⁷', 8: '⁸', 9: '⁹', 10: '¹⁰', 11: '¹¹',
  \ 12: '¹²', 13: '¹³', 14: '¹⁴', 15: '¹⁵', 16: '¹⁶',
  \ 17: '¹⁷', 18: '¹⁸', 19: '¹⁹', 20: '²⁰'
  \ }

let g:lightline.tab = {
      \ 'active': [ 'tabnum', 'filename', 'modified' ],
      \ 'inactive': [ 'tabnum', 'filename', 'modified' ] }

let g:lightline#bufferline#shorten_path      = 0
let g:lightline#bufferline#min_buffer_count  = 1
let g:lightline#bufferline#unicode_symbols   = 1
let g:lightline#bufferline#show_number       = 2
let g:lightline#bufferline#enable_devicons   = 1
let g:lightline#bufferline#filename_modifier = ':t'
let g:lightline#bufferline#clickable         = 1

nmap <Localleader>1 <Plug>lightline#bufferline#go(1)
nmap <Localleader>2 <Plug>lightline#bufferline#go(2)
nmap <Localleader>3 <Plug>lightline#bufferline#go(3)
nmap <Localleader>4 <Plug>lightline#bufferline#go(4)
nmap <Localleader>5 <Plug>lightline#bufferline#go(5)
nmap <Localleader>6 <Plug>lightline#bufferline#go(6)
nmap <Localleader>7 <Plug>lightline#bufferline#go(7)
nmap <Localleader>8 <Plug>lightline#bufferline#go(8)
nmap <Localleader>9 <Plug>lightline#bufferline#go(9)
nmap <Localleader>0 <Plug>lightline#bufferline#go(10)
""---------------------------------------------------------------------------//
function! LightlineCsv()
  if has("statusline")
    hi User1 term=standout ctermfg=0 ctermbg=11 guifg=Black guibg=Yellow
    if exists("*CSV_WCol") && &ft =~ "csv"
      return CSV_WCol("Name") . " " . CSV_WCol()
    else
      return ""
    endif
  endif
endfunction

function! LightlineGitGutter()
  if ! exists('*GitGutterGetHunkSummary')
        \ || ! get(g:, 'gitgutter_enabled', 0)
        \ || winwidth('.') <= 90
    return ''
  endif
  let symbols = [
        \ g:gitgutter_sign_added,
        \ g:gitgutter_sign_modified,
        \ g:gitgutter_sign_removed
        \ ]
  let hunks = GitGutterGetHunkSummary()
  let ret = []
  for i in [0, 1, 2]
    if hunks[i] > 0
      call add(ret, symbols[i] . ' ' . hunks[i])
    endif
  endfor
  return join(ret, ' ')
endfunction

function! LightlineModified()
  return &ft =~ 'help' ? '' : &modified ? '✎' : &modifiable ? '' : '-'
endfunction

function! LightlineReadonly()
  return &ft !~? 'help' && &previewwindow && &readonly ? '' : ''
endfunction

" Helpers -- generalise the methods for checking a ft or buftype
function! s:is_ft(ft) abort
  return &ft ==# a:ft
endfunction

function! s:is_bt(bt) abort
  return &bt ==# a:bt
endfunction

function! s:show_plain_lightline() abort
  return s:is_ft('help') ||
        \ s:is_ft('ctrlsf')||
        \ s:is_ft('coc-explorer') ||
        \ s:is_ft('terminal')||
        \ s:is_ft('neoterm')||
        \ s:is_ft('fugitive') ||
        \ s:is_bt('quickfix') ||
        \ s:is_bt('nofile') ||
        \ &previewwindow
endfunction

" This function allow me to specify titles for special case buffers
" like the previewwindow or a quickfix window
function! LightlineSpecialBuffers()
  "Credits:  https://vi.stackexchange.com/questions/18079/how-to-check-whether-the-location-list-for-the-current-window-is-open?rq=1
  let l:is_location_list = get(getloclist(0, {'winid':0}), 'winid', 0)
  return l:is_location_list ? 'Location List' :
        \ s:is_bt('quickfix') ? 'QuickFix' :
        \ &previewwindow ? 'preview' :
        \ ''
endfunction

function! LightlineFilename()
  let fname = expand('%:t')
  return fname == 'ControlP' ? g:lightline.ctrlp_item :
        \ fname == '__Tagbar__' ? '' :
        \ fname =~ '__Gundo\|NERD_tree' ? '' :
        \ s:is_ft('ctrlsf') ? '' :
        \ s:is_ft('defx') ? '' :
        \ s:is_ft('coc-explorer') ? '' :
        \ s:is_ft('vimfiler') ? vimfiler#get_status_string() :
        \ s:is_ft('unite') ? unite#get_status_string() :
        \ s:is_ft('vimshell') ? vimshell#get_status_string() :
        \ strlen(LightlineSpecialBuffers()) ? LightlineSpecialBuffers() :
        \ (strlen(LightlineReadonly()) ? LightlineReadonly() . ' ' : '') .
        \ (strlen(fname) ? fname : '[No Name]') .
        \ (strlen(LightlineModified()) ? ' ' . LightlineModified() : '')
endfunction

function! LightlineFileSize() "{{{
  let bytes = getfsize(expand("%:p"))
  if bytes <= 0
    return ""
  endif
  if bytes < 1024
    return  bytes . " b"
  else
    return  (bytes / 1024) . " kb"
  endif
endfunction "}}}

function! LightlineFiletype()
  if !strlen(&filetype) || s:show_plain_lightline()
    return ''
  endif
  let l:icon = has('gui_running') ? &filetype : WebDevIconsGetFileTypeSymbol()
  return winwidth(0) > 70 ? l:icon : ''
endfunction

function! LightlineFileFormat()
  if has('gui_running')
    return winwidth(0) > 70 ? (&fileformat . ' ') : ''
  else
    return winwidth(0) > 70 ? (&fileformat . ' ' . WebDevIconsGetFileFormatSymbol()) : ''
  endif
endfunction

function! LightlineFileencoding()
  return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

function! LightlineFugitive()
  try
    if expand('%:t') !~? 'Tagbar\|Gundo\|NERD' && &ft !~? 'vimfiler' && exists('*FugitiveHead')
      let mark = ' '
      let branch = FugitiveHead()
      return branch !=# '' ? mark.branch : ''
    endif
  catch
  endtry
  return ''
endfunction

function! LightlineMode()
  let fname = expand('%:t')
  return fname == '__Tagbar__' ? 'Tagbar' :
        \ fname == 'ControlP' ? 'CtrlP' :
        \ fname == '__Gundo__' ? 'Gundo' :
        \ fname == '__Gundo_Preview__' ? 'Gundo Preview' :
        \ fname =~ 'NERD_tree' ? 'NERDTree 🖿' :
        \ &ft ==? 'defx' ? 'Defx ⌨' :
        \ &ft == 'ctrlsf' ? 'CtrlSF 🔍' :
        \ &ft == 'vim-plug' ? 'vim-plug ⚉':
        \ &ft == 'help' ? 'help ':
        \ &ft == 'undotree' ? 'UndoTree ⮌' :
        \ &ft == 'coc-explorer' ? 'Coc Explorer' :
        \ lightline#mode()
endfunction

function LightlineAutosave() abort
  return get(b:, 'autosaved_buffer', "")
endfunction

function! s:with_default(count, icon) abort
  return a:count > 0 ? a:icon . a:count : ''
endfunction

function! LightlineGinaStatus() abort
  if !has_key(g:plugs, 'gina.vim')
    return ''
  endif
  let l:repo_name = gina#component#repo#name()
  let l:project = l:repo_name !=# '' ? ' ' .l:repo_name : ''
  " Manually recreate the traffic fancy preset as it doesn't allow granular control
  let l:ahead = gina#component#traffic#ahead() 
  let l:behind = gina#component#traffic#behind() 
  let l:traffic = s:with_default(l:ahead, '↑ ') . s:with_default(l:behind, ' ↓ ')
  return l:project . ' ' .l:traffic . ' ' " . l:status
endfunction

" Programatically derive colors for lightline mods
function! s:get_theme_background(highlight) abort
  let l:gui_bgcolor = synIDattr(hlID(a:highlight), 'bg#')
  if !strlen(l:gui_bgcolor)
    let l:gui_bgcolor = synIDattr(hlID(a:highlight), 'fg#')
  endif
  return l:gui_bgcolor
endfunction

function! s:custom_lightline_theme() abort
  " Set the colorscheme.
  if exists('g:lightline')
    " These are the colour codes that are used in the original onedark theme
    let s:normal_background = s:get_theme_background('Normal')
    let s:gold         = '#F5F478'
    let s:white        = '#abb2bf'
    let s:light_red    = '#e06c75'
    let s:dark_red     = '#be5046'
    let s:green        = '#98c379'
    let s:light_yellow = '#e5c07b'
    let s:dark_yellow  = '#d19a66'
    let s:blue         = '#61afef'
    let s:dark_blue    = '#4e88ff'
    let s:magenta      = '#c678dd'
    let s:cyan         = '#56b6c2'
    let s:gutter_grey  = '#636d83'
    let s:comment_grey = '#5c6370'

    "Lightline bufferline Colors
    let s:bright_blue  = '#A2E8F6'
    let s:tabline_background = s:theme_opts[g:colors_name]['color']
    let s:tabline_foreground = s:get_theme_background('Comment')
    let s:selected_background = s:get_theme_background('Normal')


    let s:theme = {'normal':{}, 'inactive':{}, 'insert':{}, 'replace':{}, 'visual':{}, 'tabline':{}}

    " Each subarray represents the [ForegroundColor, BackgroundColor]
    let s:theme.normal.left     = [ [ s:gold, s:normal_background ], [ s:white, s:normal_background ], [ s:dark_blue, s:normal_background ] ]
    let s:theme.normal.right    = [ [ s:dark_blue, s:normal_background ], [ s:light_yellow, s:normal_background ] ]
    let s:theme.normal.middle   = [ [ s:comment_grey, s:normal_background ] ]

    let s:theme.inactive.left   = [ [ s:comment_grey, s:normal_background ], [ s:comment_grey, s:normal_background ] ]
    let s:theme.inactive.right  = [ [ s:comment_grey, s:normal_background ], [ s:comment_grey, s:normal_background ] ]
    let s:theme.inactive.middle = [ [ s:comment_grey, s:normal_background ] ]

    let s:theme.insert.left     = [ [ s:green, s:normal_background ], [ s:comment_grey, s:normal_background ] ]
    let s:theme.insert.right    = [ [ s:dark_blue, s:normal_background ], [ s:light_red, s:normal_background ] ]
    let s:theme.insert.middle   = [ [ s:comment_grey, s:normal_background ] ]

    let s:theme.replace.left    = [ [ s:light_red, s:normal_background ], [ s:comment_grey, s:normal_background ] ]
    let s:theme.replace.right   = [ [ s:dark_blue, s:normal_background ], [ s:light_red, s:normal_background ] ]
    let s:theme.replace.middle  = [ [ s:comment_grey, s:normal_background ] ]

    let s:theme.visual.left     = [ [ s:magenta, s:normal_background ], [ s:comment_grey, s:normal_background ] ]
    let s:theme.visual.right    = [ [ s:dark_blue, s:normal_background ], [ s:light_red, s:normal_background ] ]
    let s:theme.visual.middle   = [ [ s:comment_grey, s:normal_background ] ]

    let s:theme.tabline.left    = [ [ s:tabline_foreground, s:tabline_background ] ]
    let s:theme.tabline.right   = [ [ s:tabline_foreground, s:tabline_background ] ]
    let s:theme.tabline.middle  = [ [ s:tabline_foreground, s:tabline_background ] ]
    let s:theme.tabline.tabsel  = [ [ s:bright_blue, s:selected_background ] ]

    "Select colorscheme to augment
    let s:colorscheme_palette = 'lightline#colorscheme#'.s:active_theme.'#palette'
    " using fill means we don't have to specify cterm colors
    let g:[s:colorscheme_palette] = lightline#colorscheme#fill(s:theme)
  endif
endfunction

call s:custom_lightline_theme()
