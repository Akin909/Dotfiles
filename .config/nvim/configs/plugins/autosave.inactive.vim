""---------------------------------------------------------------------------//
" AutoSave {{{1
" ----------------------------------------------------------------------------
let s:preset = "💾 AutoSaved at " . strftime("%H:%M:%S")
let g:autosave_message =  "💾 Saving..."
let g:autosave_enabled = 0

function! s:unset_autosaved() abort
    let b:autosaved_buffer = ""
endfunction

function! s:is_valid_buffer() abort
  return empty(&buftype) &&
        \ !empty(bufname('')) &&
        \ &modifiable == 1 &&
        \ &readonly == 0 &&
        \ &buftype != 'nofile'
endfunction

function! s:handle_autosave() abort
  let l:is_enabled = get(g:, 'autosave_enabled', 0)
  if s:is_valid_buffer() && l:is_enabled
    silent! update
    let b:autosaved_buffer = get(g:, 'autosave_message', s:preset)
    call timer_start(1000, { -> s:unset_autosaved() })
  endif
endfunction

augroup AutoSave
  autocmd!
  "NOTE: call is not *nested* so it doesn't trigger other autocommands
  autocmd InsertLeave,TextChanged * call s:handle_autosave()
augroup END