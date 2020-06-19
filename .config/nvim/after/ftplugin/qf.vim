" Resources and inspiration
" 1. https://github.com/ronakg/quickr-preview.vim/blob/357229d656c0340b096a16920e82cff703f1fe93/after/ftplugin/qf.vim#L215
" 2. https://github.com/romainl/vim-qf/blob/2e385e6d157314cb7d0385f8da0e1594a06873c5/autoload/qf.vim#L22

setlocal nonumber
setlocal norelativenumber
setlocal nowrap
setlocal winfixheight
setlocal colorcolumn=
" I don't want quickfix buffers to pop up when doing :bn or :bp
set nobuflisted
if has('nvim')
  highlight link QuickFixLine CursorLine
endif

function s:preview_matches(lnum) abort
  set eventignore+=all
  " Go to preview window
  keepjumps wincmd P
  " highlight the line
  execute 'match Search /\%'.a:lnum.'l^\s*\zs.\{-}\ze\s*$/'
  " go back to the quickfix
  keepjumps wincmd p
  set eventignore-=all
endfunction

function s:preview_file_under_cursor() abort
  let cur_list = getqflist()
  " get the qf entry for the current line which includes the line number
  " and the buffer number. Using those open the preview window to the specific
  " position
  let entry = cur_list[line('.') - 1]
  execute "pedit +" . entry.lnum . " " . bufname(entry.bufnr)
  call s:preview_matches(entry.lnum)
endfunction

function! s:smart_close()
  pclose!
  if winnr('$') != 1
    close
  endif
endfunction

" Autosize quickfix to match its minimum content
" https://vim.fandom.com/wiki/Automatically_fitting_a_quickfix_window_height
function! s:adjust_height(minheight, maxheight)
  exe max([min([line("$"), a:maxheight]), a:minheight]) . "wincmd _"
endfunction

call s:adjust_height(3, 10)

nnoremap <silent><buffer> <c-p> <up>
nnoremap <silent><buffer> <c-n> <down>
nnoremap <silent><nowait><buffer> p :call <SID>preview_file_under_cursor()<CR>
nnoremap <silent><nowait><buffer> q :call <SID>smart_close()<CR>