if !PluginLoaded('nvim-bufferline.lua')
  finish
endif


lua << EOF
require'bufferline'.setup {
  options = {
    view = "multiwindow",
    mappings = true,
    sort_by = "directory",
    separator_style = "slant"
  };
}
EOF

nnoremap <silent> gb :BufferLinePick<CR>
nnoremap <silent><leader><tab>  :BufferLineCycleNext<CR>
nnoremap <silent><S-tab> :BufferLineCyclePrev<CR>
if exists(':BufferLineMoveNext')
  nnoremap <silent>[b  :BufferLineMoveNext<CR>
  nnoremap <silent>]b :BufferLineMovePrev<CR>
endif
