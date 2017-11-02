""---------------------------------------------------------------------------//
" NVIM TYPESCRIPT
""---------------------------------------------------------------------------//
if !has('gui_running')
  let g:nvim_typescript#kind_symbols = {
        \ 'keyword': 'keyword',
        \ 'class': '',
        \ 'interface': 'interface',
        \ 'script': 'script',
        \ 'module': '',
        \ 'local class': 'local class',
        \ 'type': 'type',
        \ 'enum': '',
        \ 'enum member': '',
        \ 'alias': '',
        \ 'type parameter': 'type param',
        \ 'primitive type': 'primitive type',
        \ 'var': '',
        \ 'local var': '',
        \ 'property': '',
        \ 'let': '',
        \ 'const': '',
        \ 'label': 'label',
        \ 'parameter': 'param',
        \ 'index': 'index',
        \ 'function': '',
        \ 'local function': 'local function',
        \ 'method': '',
        \ 'getter': '',
        \ 'setter': '',
        \ 'call': 'call',
        \ 'constructor': '',
        \}
endif
let g:nvim_typescript#javascript_support       = 1
let g:nvim_typescript#type_info_on_hold        = 1
let g:nvim_typescript#vue_support              = 1
let g:nvim_typescript#max_completion_detail    = 1
