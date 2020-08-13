"--------------------------------------------------------------------------------
" Async Job
"--------------------------------------------------------------------------------
"
" a simple plugin to execute async jobs using the jobstart API
" inspiration: https://stackoverflow.com/questions/48709262/neovim-fugitive-plugin-gpush-locking-up
"--------------------------------------------------------------------------------
let s:state = {
      \ "data": [''],
      \}

func! s:open_preview(size) abort
  let s:shell_tmp_output = tempname()
  execute 'pedit '.s:shell_tmp_output
  wincmd P
  wincmd J
  execute('resize '. a:size)
  setlocal modifiable
  setlocal nobuflisted
  setlocal winfixheight
  setlocal nolist
  nnoremap <silent><nowait><buffer>q :bd<cr>
  nnoremap <silent><nowait><buffer><CR> :bd<cr>
endfunc

function! s:close_preview_window() abort
  normal! G
  setlocal nomodifiable
  setlocal nomodified
  " return to original window
  " wincmd p
endfunction

function! s:echo(msgs) abort
  let msg = join(a:msgs, '\n')
  echohl MoreMsg
  " double quote message so \n is interpolated
  " https://stackoverflow.com/questions/13435586/should-i-use-single-or-double-quotes-in-my-vimrc-file
  execute('echo "'.msg.'"')
  echohl clear
endfunction

func! s:process_data(shell, exit_code) abort
  if len(s:state.data) <= &cmdheight && !a:exit_code
    call s:echo(s:state.data)
  else
    call s:open_preview(len(s:state.data))
    if a:exit_code " Add the exit code if it's non-zero
      call insert(s:state.data, 'Command "'.a:shell.'" exited with '.a:exit_code)
    endif
    for item in s:state.data
      if len(item)
        call append(line('$'), item)
      endif
    endfor
    call s:close_preview_window()
  endif
endfunc

function! s:shell_cmd_completed(...) dict
  let exit_code = get(a:, '2', 0)
  call s:process_data(self.shell, exit_code)
  " terminate job
  call jobstop(self.pid)
  " reset data
  let s:state.data = ['']
endfunction

function! s:job_handler(job_id, data, event) dict
  let result = copy(a:data)
  call filter(result, 'len(v:val) > 0')
  " source: `:h on_exit`
  if len(result)
    let s:state.data[-1] .= result[0]
    call extend(s:state.data, result[1:])
  endif
endfunction

function! Exec(cmd) abort
  let s:callbacks = {
        \ 'on_stdout': function('s:job_handler'),
        \ 'on_stderr': function('s:job_handler'),
        \ 'on_exit': function('s:shell_cmd_completed'),
        \ 'shell': a:cmd
        \ }
  let pid = jobstart(a:cmd, s:callbacks)
  let s:callbacks.pid = pid
endfunction

command! GitPush call Exec('git push')
command! GitPushF call Exec('git push -f')