" if exists("b:go_after_did_ftplugin")
"   finish
" endif
"
" let b:go_after_did_ftplugin = 1 " Don't load twice in one buffer
""---------------------------------------------------------------------------//
" GO FILE SETTINGS
""---------------------------------------------------------------------------//
setlocal noexpandtab
setlocal list listchars+=tab:\│\ "(here is a space), this is to show indent line
highlight! default link goErr WarningMsg |
      \ match goErr /\<err\>/
" ---------------------------------------------------
" VIM-GO !!!
" ---------------------------------------------------
nmap <silent><leader>d <Plug>(go-doc)
nmap <silent><localleader>t  <Plug>(go-test)
nmap <silent><localleader>r  <Plug>(go-run)
nmap <silent><localleader>b :<C-u>call <SID>build_go_files()<CR>
nmap <silent><localleader>i <Plug>(go-info)
" ---------------------------------------------------
" Open Alternate files
" ---------------------------------------------------
nnoremap <silent><leader>a  :A<CR>
nnoremap <silent><leader>A  :A!<CR>
nnoremap <silent><leader>av :AV<CR>
nnoremap <silent><leader>as :AS<CR>
nnoremap <silent><leader>at :AT<CR>

nnoremap <silent><leader>fs :GoFillStruct<CR>
nnoremap <silent><leader>er :GoIfErr<CR>

"run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#cmd#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

command! -bang A call go#alternate#Switch(<bang>0, 'edit')
command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
command! -bang AS call go#alternate#Switch(<bang>0, 'split')
command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')
