" setl colorcolumn=120
setl softtabstop=4 tabstop=4 shiftwidth=4 foldmethod=indent foldlevelstart=99
setl nofoldenable
setl completeopt-=preview


if has('nvim')
  nnoremap <localleader>p :TSDefPreview<CR>
  nnoremap <leader>d :TSDef<CR>
  nnoremap gd :TSDef<CR>
  nnoremap <localleader>r :TSRefs<CR>
  nnoremap <localleader>t :TSType<CR>
  nnoremap <localleader>c :TSEditConfig<CR>
  nnoremap <localleader>i :TSImport<CR>
endif
