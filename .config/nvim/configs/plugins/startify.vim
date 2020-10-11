""---------------------------------------------------------------------------//
" STARTIFY
""---------------------------------------------------------------------------//
let g:startify_lists = [
    \ { 'type': 'sessions',  'header': ['  😸 Sessions']       },
    \ { 'type': 'dir',       'header': ['   Recently opened in '. fnamemodify(getcwd(), ':t')] },
    \ { 'type': 'files',     'header': ['   Recent']            },
    \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
    \ { 'type': 'commands',  'header': ['   Commands']       },
    \ ]

let  g:startify_bookmarks    =  [
    \ {'z': '~/.zshrc'},
    \ {'i': '~/.config/nvim/init.vim'},
    \ {'t': '~/.config/tmux/.tmux.conf'},
    \ {'d': $DOTFILES }
    \ ]

let s:vim = [
            \'██╗░░░██╗██╗███╗░░░███╗',
            \'██║░░░██║██║████╗░████║',
            \'╚██╗░██╔╝██║██╔████╔██║',
            \'░╚████╔╝░██║██║╚██╔╝██║',
            \'░░╚██╔╝░░██║██║░╚═╝░██║',
            \'░░░╚═╝░░░╚═╝╚═╝░░░░░╚═╝'
            \]

let s:neovim = [
            \'███╗░░██╗███████╗░█████╗░██╗░░░██╗██╗███╗░░░███╗',
            \'████╗░██║██╔════╝██╔══██╗██║░░░██║██║████╗░████║',
            \'██╔██╗██║█████╗░░██║░░██║╚██╗░██╔╝██║██╔████╔██║',
            \'██║╚████║██╔══╝░░██║░░██║░╚████╔╝░██║██║╚██╔╝██║',
            \'██║░╚███║███████╗╚█████╔╝░░╚██╔╝░░██║██║░╚═╝░██║',
            \'╚═╝░░╚══╝╚══════╝░╚════╝░░░░╚═╝░░░╚═╝╚═╝░░░░░╚═╝',
            \]

let s:editor_header = has('nvim') ? s:neovim : s:vim
let g:header = s:editor_header + ["", ""]

let g:header_suffix = [
            \ '',
            \ ' Plugins loaded: '.len(get(g:, 'plugs', 0)).' ',
            \]

let g:startify_custom_header = 'startify#pad(g:header + startify#fortune#boxed() + g:header_suffix)'

let g:startify_commands = [
    \ {'pu': ['Update plugins',':PlugUpdate | PlugUpgrade']},
    \ {'ps': ['Plugins status', ':PlugStatus']},
    \ {'h':  ['Help', ':help']}
    \ ]

let g:startify_fortune_use_unicode    = 1
let g:startify_session_autoload       = 1
let g:startify_session_delete_buffers = 1
let g:startify_session_persistence    = 1
let g:startify_update_oldfiles        = 1
let g:startify_session_sort           = 1
let g:startify_change_to_vcs_root     = 1
"}}}
