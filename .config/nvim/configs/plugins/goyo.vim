""---------------------------------------------------------------------------//
" Goyo
""---------------------------------------------------------------------------//
if exists("g:gui_oni") || !has_key(g:plugs, "goyo.vim")
  finish
endif

let g:goyo_margin_top = 2
let g:goyo_margin_bottom = 2

nnoremap <leader>G :Goyo<CR>

function! s:goyo_enter()
  if executable('tmux') && strlen($TMUX)
    silent !tmux set status off
    silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
  endif
  set showtabline=0
  let b:quitting = 0
  let b:quitting_bang = 0
  autocmd QuitPre <buffer> let b:quitting = 1
  cabbrev <buffer> q! let b:quitting_bang = 1 <bar> q!
endfunction

function! s:goyo_leave()
  if exists('$TMUX')
    silent !tmux set status on
    silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
  endif
  set showtabline=2
  " Quit Vim if this is the only remaining buffer
  if b:quitting && len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) == 1
    if b:quitting_bang
      qa!
    else
      qa
    endif
  endif
endfunction

autocmd! User GoyoLeave nested call <SID>goyo_leave()
autocmd! User GoyoEnter nested call <SID>goyo_enter()

function! s:auto_goyo()
  if &ft == 'markdown'
    Goyo 80
  elseif exists('#goyo')
    let bufnr = bufnr('%')
    Goyo!
    execute 'b '.bufnr
  endif
endfunction

" FIXME specifically calling goyo in the context of a function
" seems to cause the colorscheme from being refreshed
" augroup goyo_markdown
"   autocmd!
"   autocmd BufEnter * call s:auto_goyo()
" augroup END
"}}}