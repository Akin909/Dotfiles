function! tmux#statusline_colors() abort
  " Get the color of the current vim background and update tmux accordingly
  let bg_color = synIDattr(hlID('Normal'), 'bg')
  call jobstart('tmux set-option -g status-style bg=' . bg_color)
  " TODO: on vim leave we should set this back to what it was
endfunction

function! tmux#on_enter() abort
  try
    let fname = expand("%:t")
    if strlen(fname)
      let session_file = strlen(v:this_session) ? v:this_session : 'Neovim'
      " NOTE this is here for plugins like "prosession/obsession"
      " which modify the session name into "path/to/session/file%name%.vim
      " explainer ->
      " :t -> get the tail
      " :gs?subject?replacement?
      " get the tail of that -> :r remove the extension
      " see :h filename-modifier for details
      let fname_pattern = empty(matchstr(session_file, '%')) ?
            \ ':t' : ':t:gs?%?/?:t:r'
      let session = fnamemodify(session_file, fname_pattern)
      let [icon, hl] = utils#get_devicon(bufname())
      let color = synIDattr(hlID(hl), 'fg')
      let window_title = session . ' • ' . '#[fg='.color.']'.icon
      let cmd = printf("tmux rename-window '%s'", window_title)
      call jobstart(cmd)
    endif
  catch /.*/
  endtry
endfunction

function! tmux#on_leave() abort
  call jobstart('tmux set-window-option automatic-rename on')
endfunction
