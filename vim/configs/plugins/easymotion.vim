""---------------------------------------------------------------------------//
"EasyMotion mappings
""---------------------------------------------------------------------------//
let g:EasyMotion_prompt = 'Jump to → '
let g:EasyMotion_do_mapping       = 0
let g:EasyMotion_startofline      = 0
let g:EasyMotion_smartcase        = 1
let g:EasyMotion_use_smartsign_us = 1
omap t <Plug>(easymotion-bd-tl)
omap T <Plug>(easymotion-bd-tl)
omap f <Plug>(easymotion-bd-f)

" nmap s <Plug>(easymotion-s)
" Jump to anywhere with only `s{char}{target}`
" `s<CR>` repeat last find motion.
map s <Plug>(easymotion-f)
nmap s <Plug>(easymotion-overwin-f)
" Move to line
map <Leader>L <Plug>(easymotion-bd-jk)
nmap <Leader>L <Plug>(easymotion-overwin-line)
" Move to character
map <leader>s <Plug>(easymotion-sl)
" Move to word
map <leader>w <Plug>(easymotion-bd-wl)
nnoremap <leader>/ /
map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)
map  <leader>n <Plug>(easymotion-next)
map  <leader>N <Plug>(easymotion-prev)
