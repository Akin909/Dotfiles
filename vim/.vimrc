" ________  ___  __    ___  ________   ________           ________  ________  ________   ________ ___  ________
"|\   __  \|\  \|\  \ |\  \|\   ___  \|\   ____\         |\   ____\|\   __  \|\   ___  \|\  _____\\  \|\   ____\
"\ \  \|\  \ \  \/  /|\ \  \ \  \\ \  \ \  \___|_        \ \  \___|\ \  \|\  \ \  \\ \  \ \  \__/\ \  \ \  \___|
" \ \   __  \ \   ___  \ \  \ \  \\ \  \ \_____  \        \ \  \    \ \  \\\  \ \  \\ \  \ \   __\\ \  \ \  \  ___
"  \ \  \ \  \ \  \\ \  \ \  \ \  \\ \  \|____|\  \        \ \  \____\ \  \\\  \ \  \\ \  \ \  \_| \ \  \ \  \|\  \
"   \ \__\ \__\ \__\\ \__\ \__\ \__\\ \__\____\_\  \        \ \_______\ \_______\ \__\\ \__\ \__\   \ \__\ \_______\
"    \|__|\|__|\|__| \|__|\|__|\|__| \|__|\_________\        \|_______|\|_______|\|__| \|__|\|__|    \|__|\|_______|
"                                        \|_________|


"Sections of this vimrc can be folded or unfolded using za, they are marked with 3 curly braces


set nocompatible "IMproved, required
filetype off " required  Prevents potential side-effects
" from system ftdetects scripts
"-----------------------------------------------------------
"PLUGINS {{{
"-----------------------------------------------------------
"This will autoinstall vim plug if not already installed
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

"set the runtime path to include Vundle and initialise
call plug#begin('~/.vim/plugged')

if !has('nvim')
  if has('unix')
    if empty($SSH_CONNECTION)
      Plug 'Valloric/YouCompleteMe', { 'do': './install.py --gocode-completer --tern-completer' }
    endif
  endif
else
  Plug 'Shougo/deoplete.nvim', { 'do': 'UpdateRemotePlugins' }
endif
Plug 'w0rp/ale' " Ale  Async Linting as you type
Plug 'SirVer/ultisnips' "Added vim snippets for code autofilling
"================================
Plug 'scrooloose/nerdtree' "Added nerdtree filetree omnitool : )
Plug 'mattn/emmet-vim' "Added emmet vim plugin
Plug 'Raimondi/delimitMate' "Add delimitmate
Plug 'easymotion/vim-easymotion' "Added easy motions
function! BuildTern(info)
  if a:info.status == 'installed' || a:info.force
    !npm install
  endif
endfunction
Plug 'ternjs/tern_for_vim',{'do':function('BuildTern')}  "Add Tern for autocompletion
Plug 'mhinz/vim-startify' " A fun start up sceen for vim + session management to boot
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } | Plug 'junegunn/fzf.vim'
Plug 'sbdchd/neoformat' " Autoformatter
Plug 'tpope/vim-capslock' "Capslock without a capslock key in vim
Plug 'junegunn/vim-easy-align', { 'on': [ '<Plug>(EasyAlign)' ] } "Added June Gunn's alignment plugin

"TMUX ============================
if executable("tmux")
  Plug 'benmills/vimux' "Vimux i.e send commands to a tmux split
  Plug 'christoomey/vim-tmux-navigator' "Navigate panes in vim and tmux with the same bindings
  " Plug 'sjl/vitality.vim'
endif

" "Utilities============================
Plug 'sjl/gundo.vim',{'on':'GundoToggle'} "Add Gundo - undo plugin for vim
Plug 'chip/vim-fat-finger', { 'on':[] } "Autocorrects 4,000 common typos
augroup load_fat_finger
  autocmd!
  autocmd InsertEnter * call plug#load('vim-fat-finger')
        \| autocmd! load_fat_finger
augroup END
Plug 'osyo-manga/vim-over' "Highlighting for substitution in Vim
" , {'on': 'OverCommandLine'} - premature optimisation
Plug 'itchyny/vim-cursorword' "Underlines instances of word under the cursor
Plug 'junegunn/goyo.vim', { 'for': 'markdown' } "Peace and Quiet thanks JGunn

"TPOPE ====================================
"Very handy plugins and functionality by Tpope (ofc)
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive' " Add fugitive git status and command plugins
Plug 'tpope/vim-eunuch' " Adds file manipulation functionality
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat' " . to repeat more actions
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-abolish'

"Syntax ============================
Plug 'sheerun/vim-polyglot'| Plug 'othree/javascript-libraries-syntax.vim', { 'for':'javascript' } "Added vim polyglot a collection of language packs for vim
Plug 'Valloric/MatchTagAlways', { 'for':'html' }
Plug 'editorconfig/editorconfig-vim' "Added Editor Config plugin to maintain style choices

"Marks =============================
" Plug 'kshenoy/vim-signature' "Vim signature re-added because I need to see my bloody marks

"Git ===============================
Plug 'junegunn/vim-github-dashboard', { 'on': ['GHDashboard', 'GHActivity'] } "Github dashboard for vim
Plug 'airblade/vim-gitgutter' "Add a GitGutter to track new lines re git file
Plug 'rhysd/committia.vim' "create diff window and Gstatus window on commit

"Text Objects =====================
Plug 'kana/vim-textobj-user' "Text object library plugin for defining your own text objects
Plug 'glts/vim-textobj-comment' "Text obj for comments
Plug 'rhysd/vim-textobj-conflict' "Conflict marker text objects
Plug 'bkad/CamelCaseMotion' "uses a prefix of the leader key to implement text objects e.g. ci<leader>w will change all of one camelcased word
Plug 'michaeljsmith/vim-indent-object' " Add text object for indented code = 'i' i.e dii delete inner indented block
Plug 'terryma/vim-expand-region' " All encompasing v
Plug 'wellle/targets.vim' "Moar textobjs

"Search Tools =======================
Plug 'dyng/ctrlsf.vim' "Excellent for multiple search and replace functionality

"Coding tools =======================
Plug 'konfekt/fastfold'
Plug 'heavenshell/vim-jsdoc', { 'on': '<Plug>(jsdoc)' } "Add JSDocs plugin
Plug 'majutsushi/tagbar', { 'on': [ 'TagbarToggle' ] } "Add Tagbar Plugin
Plug 'ludovicchabant/vim-gutentags' "Add Plugin to manage tag files

"Filetype Plugins ======================
Plug 'shime/vim-livedown' "Add better markdown previewer
Plug 'fatih/vim-go',{ 'for': 'go', 'do': ':GoInstallBinaries' } "Go for Vim

"Themes ===============================
Plug 'rhysd/try-colorscheme.vim', {'on':'TryColorscheme'}
Plug 'tyrannicaltoucan/vim-quantum' "Quantum theme
Plug 'rakr/vim-one'
Plug 'ryanoasis/vim-devicons' " This Plugin must load after the others - Add file type icons to vim

"Plugins I think I need yet never use ===============================
Plug 'Yggdroot/indentLine'
"MAPPINGS =================================================
" Plug '~/Dotfiles/vim/mappings.vim'
" STATUS LINE --------------------
" see statuline.vim file
" Plug '~/Dotfiles/vim/statusline.vim'
" Plug 'tweekmonster/startuptime.vim', {'on': 'StartupTime'} "Start up time monitor
" Plug 'lifepillar/vim-cheat40'

"Vim HARDMODE ----------------------
" Plug 'wikitopian/hardmode'
" Preview colors in source code
" Plug 'ap/vim-css-color'
"Codi - A REPL in vim

call plug#end()

" filetype plugin indent on - ESSENTIAL but initialised by vim-plug
" syntax enable
"Added built in match it plugin to vim the longer command a la tpope only loads
"this the user has not already installed a new version of matchit
" packadd! matchit
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif

"}}}
"====================================================================================
"Leader bindings
"====================================================================================
let mapleader = "," "Remap leader key
let maplocalleader = "\<space>" "Local leader key
"--------------------------------------------------------------------------------------------------
"COMMANDS {{{
"--------------------------------------------------------------------------------------------------
"--------------------------------------------------------------------------------------------------
"PLUGIN MAPPINGS {{{
"--------------------------------------------------------------------------------------------------
"--------------------------------------------
" CTRLSF - CTRL-SHIFT-F
"--------------------------------------------
let g:ctrlsf_default_root = 'project' "Search at the project root i.e git or hg folder
nmap     <C-F>f <Plug>CtrlSFPrompt
vmap     <C-F>f <Plug>CtrlSFVwordPath
vmap     <C-F>F <Plug>CtrlSFVwordExec
nmap     <C-F>n <Plug>CtrlSFCwordPath
nmap     <C-F>p <Plug>CtrlSFPwordPath
nnoremap <C-F>o :CtrlSFOpen<CR>
nnoremap <C-F>t :CtrlSFToggle<CR>
inoremap <C-F>t <Esc>:CtrlSFToggle<CR>

"--------------------------------------------
" FZF bindings
"--------------------------------------------
" --column: Show column number
" --line-number: Show line number
" --no-heading: Do not show file headings in results
" --fixed-strings: Search term as a literal string
" --ignore-case: Case insensitive search
" --no-ignore: Do not respect .gitignore, etc...
" --hidden: Search hidden files and folders
" --follow: Follow symlinks
" --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
" --color: Search color options
command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow  --color "always" '.shellescape(<q-args>), 1, <bang>0)
let g:fzf_files_options =
      \ '--preview "(highlight -O ansi {} || cat {}) 2> /dev/null | head -'.&lines.'"'
" Use ripgrep instead of ag:
command! -bang -nargs=* Rg
      \ call fzf#vim#grep(
      \   'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
      \   <bang>0 ? fzf#vim#with_preview('up:60%')
      \           : fzf#vim#with_preview('right:50%:hidden', '?'),
      \   <bang>0)
" Advanced customization using autoload functions
" Replace the default dictionary completion with fzf-based fuzzy completion
inoremap <expr> <c-x><c-k> fzf#complete('cat /usr/share/dict/words')

nnoremap <silent> <localleader>o :Buffers<CR>
nnoremap <silent> <localleader>a :Windows<CR>
nnoremap <silent> <localleader>a :Windows<CR>
nnoremap <silent> <localleader>H :History<CR>
nnoremap <silent> <localleader>C :Commits<CR>

function! SearchWordWithRg()
  execute 'Rg' expand('<cword>')
endfunction
" Launch file search using FZF - FZFR Uses the project's root regardless of where vim is
nnoremap <C-P> :FZFR <CR>
" nnoremap <space>\ :Find<space>
nnoremap \ :Rg<CR>
nnoremap <space>\ :call SearchWordWithRg()<CR>
" nnoremap <C-P> :Files <CR> " Uses the pwd

"This allows me to use control-f to jump out of a newly matched pair (courtesty
"of delimitmate)
imap <C-F> <C-g>g

nnoremap gm :LivedownToggle<CR>

let g:textobj_comment_no_default_key_mappings = 1
xmap ac <Plug>(textobj-comment-a)
omap ac <Plug>(textobj-comment-a)
xmap ic <Plug>(textobj-comment-i)
omap ic <Plug>(textobj-comment-i)
"--------------------------------------------

"-----------------------------------------------------------
"     ALE
"-----------------------------------------------------------
let g:ale_echo_msg_format = '%linter%: %s [%severity%]'
let g:ale_sign_column_always = 1
let g:ale_sign_error         = '✘' "✖️
let g:ale_sign_warning       = '⚠️'
let g:ale_linters            = {'jsx': ['stylelint', 'eslint']}
let g:ale_linter_aliases     = {'jsx': 'css'}
let g:ale_set_highlights = 0
" nmap <silent> <C-/> <Plug>(ale_previous_wrap)
nmap <silent> <C-\> <Plug>(ale_next_wrap)

imap <C-L> <C-O><Plug>CapsLockToggle
"--------------------------------------------
"Fugitive bindings
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gd :Gdiff<CR>
nnoremap <leader>gc :Gcommit<CR>
nnoremap <leader>gp :Gpush<CR>
nnoremap <leader>gb :Gbrowse<CR> "Open current file on github.com
vnoremap <leader>gb :Gbrowse<CR> "Make it work in Visual mode to open with highlighted linenumbers
" Push the repository of the currently opened file
" nnoremap <leader>gp :call VimuxRunCommandInDir("git push", 0)<CR>
"--------------------------------------------
" JSX & POLYGLOT
"--------------------------------------------
" let g:polyglot_disabled = ['jsx'] "Setting I might need in the future
let g:jsx_ext_required = 0 "JSX files are not treated as js - so vim-jsx does not auto apply, fixes folding issues

"VIM-GO
let g:go_doc_keywordprg_enabled = 0
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1

"--------------------------------------------
" Indent guides
"--------------------------------------------
let g:indentLine_bufNameExclude = ['_.*', 'NERD_tree.*']
let g:indentLine_fileType = ['c', 'cpp','javascript','javascript.jsx']
let g:indentLine_char = '┆'

let g:gitgutter_sign_modified = '•'
let g:gitgutter_eager = 1
let g:gitgutter_sign_added    = '❖'
let g:gitgutter_sign_column_always = 1
let g:gitgutter_eager              = 1
let g:gitgutter_grep_command = 'ag --nocolor'

vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

nnoremap <C-F> :Neoformat<CR>

" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vnoremap <Enter> <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)

" let g:javascript_conceal_arrow_function = "⇒"
" let g:javascript_conceal_return         = "⇚"
let g:javascript_conceal_undefined = "¿"
let g:javascript_conceal_super     = "Ω"
let g:javascript_conceal_null      = "ø"
let g:javascript_plugin_jsdoc      = 1

let g:committia_hooks = {}

function! g:committia_hooks.edit_open(info)
  " Additional settings
  setlocal spell
  " If no commit message, start with insert mode
  if a:info.vcs ==# 'git' && getline(1) ==# ''
    startinsert
  end
  " Scroll the diff window from insert mode
  " Map <C-n> and <C-p>
  imap <buffer><C-n> <Plug>(committia-scroll-diff-down-half)
  imap <buffer><C-p> <Plug>(committia-scroll-diff-up-half)
endfunction

"Toggle Tagbar
nnoremap <leader>2 :TagbarToggle<CR>

"Vimux ==========================================================
"Tell vimux to run commands in a new split
let VimuxUseNearest = 0
let VimuxResetSequence = ""

nnoremap <F5> :call VimuxRunCommand('browse')<CR>
" Prompt for a command to run
nnoremap <Leader>vp :VimuxPromptCommand<CR>
" Run last command executed by VimuxRunCommand
nnoremap <Leader>vl :VimuxRunLastCommand<CR>
" Inspect runner pane
nnoremap <Leader>vi :VimuxInspectRunner<CR>
" Close vim tmux runner opened by VimuxRunCommand
nnoremap <Leader>vq :VimuxCloseRunner<CR>
" Interrupt any command running in the runner pane
nnoremap <Leader>vx :VimuxInterruptRunner<CR>
" Zoom the runner pane (use <bind-key> z to restore runner pane)
nnoremap <Leader>vz :call VimuxZoomRunner()<CR>

"Vim-Signature ==================================================
let g:SignatureMarkTextHLDynamic=1
"NERDTree
" =============================================
" Ctrl+N to toggle Nerd Tree
nnoremap <C-N> :NERDTreeToggle<CR>
nnoremap <localleader>nf :NERDTreeFind<CR>

let g:NERDTreeHijackNetrw             = 0 "Off as it messes with startify's autoload session
let g:NERDTreeAutoDeleteBuffer        = 1
let g:NERDTreeDirArrowExpandable      = '├'
let g:NERDTreeDirArrowCollapsible     = '└'
let NERDTreeQuitOnOpen                = 1
let NERDTreeMinimalUI                 = 1
let NERDTreeDirArrows                 = 1
let NERDTreeCascadeOpenSingleChildDir = 1
let g:NERDTreeShowBookmarks           = 1
let NERDTreeAutoDeleteBuffer          = 1
let NERDTreeShowHidden                = 1 "Show hidden files by default

"===================================================
" Vim-Over - Highlight substitution parameters
"===================================================
nmap <C-/> <esc>:OverCommandLine<CR>:s/
"===================================================
"EasyMotion mappings
"===================================================
let g:EasyMotion_do_mapping = 0 "Disable default mappings
" Use uppercase target labels and type as a lower case
" let g:EasyMotion_use_upper  1
" type `l` and match `l`&`L`
let g:EasyMotion_smartcase = 1
" Smartsign (type `3` and match `3`&`#`)
let g:EasyMotion_use_smartsign_us = 1
" keep cursor column when jumping
let g:EasyMotion_startofline = 0
" Bidirectional & within line 't' motion
omap t <Plug>(easymotion-bd-tl)
" nmap s <Plug>(easymotion-s)
" Jump to anwhere with only `s{char}{target}`
" `s<CR>` repeat last find motion.
map s <Plug>(easymotion-f)
nmap s <Plug>(easymotion-overwin-f)
" JK motions: Line motions
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
"Search with easy motion
map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)
map  n <Plug>(easymotion-next)
map  N <Plug>(easymotion-prev)

"=======================================================================
"                    EMMET for Vim
"=======================================================================
"Emmet for vim leader keymap
let g:user_emmet_leader_key     = "<C-Y>"
let g:user_emmet_expandabbr_key =  "<C-Y>"
let g:user_emmet_install_global = 0
" let g:user_emmet_leader_key     = "<s-tab>"

nnoremap <leader>u :GundoToggle<CR>

"Set up libraries to highlight with library syntax highlighter
let g:used_javascript_libs = 'underscore,jquery,angularjs,mocha,react,jasmine,chai,handlebars,requirejs'
"}}}
"====================================================================================
"AUTOCOMMANDS {{{
"===================================================================================
" Close help and git window by pressing q.
augroup quickfix_menu_quit
  autocmd!
  autocmd FileType help,git-status,git-log,qf,
        \gitcommit,quickrun,qfreplace,ref,
        \simpletap-summary,vcs-commit,vcs-status,vim-hacks
        \ nnoremap <buffer><silent> q :<C-u>call <sid>smart_close()<CR>
  autocmd FileType * if (&readonly || !&modifiable) && !hasmapto('q', 'n')
        \ | nnoremap <buffer><silent> q :<C-u>call <sid>smart_close()<CR>| endif
augroup END

function! s:smart_close()
  if winnr('$') != 1
    close
  endif
endfunction

" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#cmd#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

augroup Go_Mappings
  autocmd!
  autocmd Filetype go setlocal noexpandtab tabstop=4 shiftwidth=4 nolist
  autocmd BufNewFile,WinEnter,BufRead *.go setlocal nolist
  autocmd FileType go nmap <leader>t  <Plug>(go-test)
  autocmd FileType go nmap <Leader>d <Plug>(go-doc)
  autocmd FileType go nmap <leader>r  <Plug>(go-run)
  autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>
augroup END

augroup CheckOutsideTime - "excellent function but implemented by terminus
  autocmd!
  autocmd WinEnter,BufRead,BufEnter,FocusGained * silent! checktime " automatically check for changed files outside vim
  au FocusLost * silent! wa "Saves all files on switching tabs i.e losing focus, ignoring warnings about untitled buffers
augroup end

" Disable paste.
augroup Cancel_Paste
  autocmd!
  autocmd InsertLeave *
        \ if &paste | set nopaste | echo 'nopaste' | endif
augroup END

augroup reload_vimrc
  autocmd!
  autocmd bufwritepost $MYVIMRC nested source $MYVIMRC
augroup END

" automatically leave insert mode after 'updatetime' milliseconds of inaction
augroup updating_time
  autocmd!
  autocmd InsertEnter * let updaterestore=&updatetime | set updatetime=10000
  autocmd InsertLeave * let &updatetime=updaterestore
augroup END

augroup VimResizing
  autocmd!
  "Command below makes the windows the same size on resizing !? Why?? because
  "its tidier
  autocmd VimResized * wincmd =
  autocmd FocusLost * :wa
  autocmd VimResized * :redraw! | :echo 'Redrew'
augroup END

augroup filetype_completion
  autocmd!
  autocmd FileType html,css,javascript,javascript.jsx EmmetInstall
  autocmd FileType css,scss,sass,stylus,less setl omnifunc=csscomplete#CompleteCSS
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType javascript,javascript.jsx,jsx setlocal omnifunc=tern#Complete
  autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
augroup END

augroup filetype_javascript
  autocmd!
  "PRETTIER FOR VIM  ================
  autocmd FileType javascript.jsx,javascript setlocal formatprg=prettier\ --stdin\ --single-quote\ --trailing-comma\ es5
  autocmd BufWritePost *.js,*.jsx Neoformat
  "==================================
  autocmd FileType javascript nnoremap <buffer> <leader>cc I{/*<C-O>A */}<esc>
  autocmd FileType javascript :iabbrev <buffer> und undefined
  autocmd Filetype javascript setlocal nocindent "don't use cindent for javascript
  autocmd BufRead,BufNewFile Appraisals set filetype=ruby
  autocmd BufRead,BufNewFile .{jscs,jshint,eslint}rc set filetype=json
  " autocmd FileType javascript setlocal concealcursor=nvic
augroup END

augroup FileType_html
  autocmd!
  "for emmet
  autocmd Filetype html noremap <buffer> <C-G> :Neoformat<CR>
  autocmd BufWritePost *.html Neoformat
  autocmd FileType html nnoremap <buffer> <localleader>G Vatzf
  autocmd BufNewFile, BufRead *.html setlocal nowrap :normal gg:G
augroup END


augroup FileType_markdown
  autocmd!
  au Filetype markdown setlocal nonumber
  autocmd BufNewFile, BufRead *.md setlocal spell spelllang=en_uk "Detect .md files as mark down
  autocmd BufNewFile,BufReadPost *.md set filetype=markdown
  autocmd BufNewFile,BufRead *.md :onoremap <buffer>ih :<c-u>execute "normal! ?^==\\+$\r:nohlsearch\rkvg_"<cr>
  autocmd BufNewFile,BufRead *.md :onoremap <buffer>ah :<c-u>execute "normal! ?^==\\+$\r:nohlsearch\rg_vk0"<cr>
  autocmd BufNewFile,BufRead *.md :onoremap <buffer>aa :<c-u>execute "normal! ?^--\\+$\r:nohlsearch\rg_vk0"<cr>
  autocmd BufNewFile,BufRead *.md :onoremap <buffer>ia :<c-u>execute "normal! ?^--\\+$\r:nohlsearch\rkvg_"<cr>
  autocmd BufNewFile,BufRead *.md :nnoremap <buffer><leader>+ :HeaderIncrease<cr>
  autocmd BufNewFile,BufRead *.md :nnoremap <buffer><leader>- :HeaderDecrease<cr>
augroup END

augroup filetype_vim
  "Vimscript file settings -------------------------
  autocmd!
  "This command makes vim start a file with all folds closed
  autocmd FileType vim setlocal foldmethod=marker
  " autocmd FileType vim setlocal foldlevelstart=0
  autocmd CmdwinEnter * nnoremap <silent><buffer> q <C-W>c
augroup END

augroup FileType_text
  autocmd!
  autocmd FileType text setlocal textwidth=78
augroup END

augroup FileType_all
  autocmd!
  au FileType python setl ts=4
  au FileType rust setl sw=0 sts=0
  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  " Set syntax highlighting for specific file types
  autocmd BufReadPost *
        \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal g`\"" |
        \ endif

  if exists("*mkdir") "auto-create directories for new files
    au BufWritePre,FileWritePre * silent! call mkdir(expand('<afile>:p:h'), 'p')
  endif
augroup END

augroup fugitiveSettings
  autocmd!
  autocmd FileType gitcommit setlocal nolist
  autocmd BufReadPost fugitive://* setlocal bufhidden=delete
augroup END
"Close vim if only window is a Nerd Tree
augroup NERDTree
  autocmd!
  autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
augroup END

augroup Toggle_number
  autocmd!
  " toggle relativenumber according to mode, don't do this for markdown
  if &ft != 'markdown'
    autocmd InsertEnter * set relativenumber!
    autocmd InsertLeave * set relativenumber
  endif
augroup END
"Stolen from HiCodin's Dotfiles a really cool set of fold text functions
function! NeatFoldText()
  let line = ' ' . substitute(getline(v:foldstart), '^\s*"\?\s*\|\s*"\?\s*{{' . '{\d*\s*', '', 'g') . ' '
  let lines_count = v:foldend - v:foldstart + 1
  let lines_count_text = '(' . ( lines_count ) . ')'
  let foldtextstart = strpart('✦' . line, 0, (winwidth(0)*2)/3)
  let foldtextend = lines_count_text . repeat(' ', 2 )
  let foldtextlength = strlen(substitute(foldtextstart . foldtextend, '.', 'x', 'g')) + &foldcolumn
  return foldtextstart . repeat(' ', winwidth(0)-foldtextlength) . foldtextend
endfunction
set foldtext=NeatFoldText()
" }}}
" Javascript {{{
function! FoldText()
  let line = ' ' . substitute(getline(v:foldstart), '{.*', '{...}', ' ') . ' '
  let lines_count = v:foldend - v:foldstart + 1
  let lines_count_text = '(' . ( lines_count ) . ')'
  let foldchar = matchstr(&fillchars, 'fold:\')
  let foldtextstart = strpart('✦' . repeat(foldchar, v:foldlevel*2) . line, 0, (winwidth(0)*2)/3)
  let foldtextend = lines_count_text . repeat(' ', 2 )
  let foldtextlength = strlen(substitute(foldtextstart . foldtextend, '.', 'x', 'g')) + &foldcolumn
  return foldtextstart . repeat(' ', winwidth(0)-foldtextlength) . foldtextend . ' '
endfunction
augroup jsfolding
  autocmd!
  autocmd FileType javascript,javascript.jsx,jsx setlocal foldenable|setlocal foldmethod=syntax |setlocal foldtext=FoldText()
  au Filetype javascript,javascript.jsx,jsx setlocal foldlevelstart=20 | norm zR
augroup END
" }}}
" CSS {{{
function! CSSFoldText()
  let line = substitute(getline(v:foldstart), '{.*', '{...}', ' ') . ' '
  let lines_count = v:foldend - v:foldstart + 1
  let lines_count_text = '(' . ( lines_count ) . ')'
  let foldchar = matchstr(&fillchars, 'fold:\')
  let foldtextstart = strpart('✦ ' . line, 0, (winwidth(0)*2)/3)
  let foldtextend = lines_count_text . repeat(' ', 2 )
  let foldtextlength = strlen(substitute(foldtextstart . foldtextend, '.', 'x', 'g')) + &foldcolumn
  return foldtextstart . repeat(' ', winwidth(0)-foldtextlength) . foldtextend . ' '
endfunction
augroup ft_css
  au!
  au Filetype css setlocal foldmethod=marker
  au Filetype css setlocal foldmarker={,}
  au FileType css setlocal foldtext=CSSFoldText()
  au BufWritePost *.css Neoformat
augroup END
let g:html_indent_tags = 'li\|p' " Treat <li> and <p> tags like the block tags they are
"}}}
"====================================================================================
"Spelling
"====================================================================================
" Chang default highlighting for spellbad, the default is really bad
highlight clear SpellBad
highlight SpellBad  term=underline cterm=italic ctermfg=Red
highlight clear SpellCap
highlight SpellCap  term=underline cterm=italic ctermfg=Blue
highlight clear SpellLocal
highlight SpellLocal  term=underline cterm=italic ctermfg=Blue
highlight clear SpellRare
highlight SpellRare  term=underline cterm=italic ctermfg=Blue
" Set spellfile to location that is guaranteed to exist, can be symlinked to
" Dropbox or kept in Git.
set spellfile=$HOME/.vim-spell-en.utf-8.add
set fileformats=unix,dos,mac
" Autocomplete with dictionary words when spell check is on
set complete+=kspell
"Add spell checking local
" setlocal spell spelllang=en_us

"===================================================================================
"Mouse {{{
"===================================================================================
set mousehide
set mouse=a "this is the command that works for mousepad
if !has('nvim')
  set ttymouse=xterm2
endif

" Swap iTerm2 cursors in [n]vim insert mode when using tmux, more here https://gist.github.com/andyfowler/1195581
if exists('$TMUX')
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

if !has('nvim')
  function! ToggleMouse()
    " check if mouse is enabled
    if &mouse == 'a'
      " disable mouse
      set mouse=
    else
      " enable mouse everywhere
      set mouse=a
    endif
  endfunc
  "Try being more lenient
  noremap <ScrollWheelUp>      <nop>
  noremap <S-ScrollWheelUp>    <nop>
  noremap <C-ScrollWheelUp>    <nop>
  noremap <ScrollWheelDown>    <nop>
  noremap <S-ScrollWheelDown>  <nop>
  noremap <C-ScrollWheelDown>  <nop>
  noremap <ScrollWheelLeft>    <nop>
  noremap <S-ScrollWheelLeft>  <nop>
  noremap <C-ScrollWheelLeft>  <nop>
  noremap <ScrollWheelRight>   <nop>
  noremap <S-ScrollWheelRight> <nop>
  noremap <C-ScrollWheelRight> <nop>
  nnoremap <F7> :call ToggleMouse()<CR>
endif
"}}}
"====================================================================================
"Buffer and Tab settings {{{
"====================================================================================
" This allows buffers to be hidden if you've modified a buffer.
" This is almost a must if you wish to use buffers in this way.
set nohidden

" Zoom / Restore window.
function! s:ZoomToggle() abort
  if exists('t:zoomed') && t:zoomed
    exec t:zoom_winrestcmd
    let t:zoomed = 0
  else
    let t:zoom_winrestcmd = winrestcmd()
    resize
    vertical resize
    let t:zoomed = 1
  endif
endfunction
command! ZoomToggle call s:ZoomToggle()
nnoremap <silent> <leader>z :ZoomToggle<CR>

" To open a new empty buffer
" This replaces :tabnew which I used to bind to this mapping
nnoremap <leader>n :enew<cr>
" Close a tab
nnoremap <leader>tc :tabclose<CR>
" Close the current buffer and move to the previous one
" This replicates the idea of closing a tab
nnoremap ,q :bp <BAR> bd #<CR>
" " Show all open buffers and their status
nnoremap <leader>bl :ls<CR>
"}}}
" ----------------------------------------------------------------------------
" Message output on vim actions
" ----------------------------------------------------------------------------
set shortmess+=t                      " truncate file messages at start
set shortmess+=A                      " ignore annoying swapfile messages
set shortmess+=O                      " file-read message overwrites previous
set shortmess+=T                      " truncate non-file messages in middle
set shortmess+=W                      " don't echo "[w]"/"[written]" when writing
set shortmess-=l
set shortmess+=a                      " use abbreviations in messages eg. `[RO]` instead of `[readonly]`
" set shortmess+=I                      " no splash screen
" set shortmess-=f                      " (file x of x) instead of just (x of x)
" set shortmess+=mnrxoOt
if has('patch-7.4.314')
  set shortmess+=c                    " Disable 'Pattern not found' messages
endif

" ----------------------------------------------------------------------------
" Window splitting and buffers
" ----------------------------------------------------------------------------
" Set minimal width for current window.
set winwidth=30
set splitbelow "Open a horizontal split below current window
set splitright "Open a vertical split to the right of the window
if has('folding')
  if has('windows')
    set fillchars=vert:│                  " Vertical sep between windows (unicode)- ⣿
    set fillchars+=fold:-
  endif
  " set foldmethod=indent "fast fold plugin requires specific filetype folding
  set foldlevelstart=99
  set foldnestmax=3           " deepest fold is 3 levels
endif
" reveal already opened files from the quickfix window instead of opening new
" buffers
" Specify the behavior when switching between buffers
try
  set switchbuf=useopen,usetab,newtab
catch
endtry

" ----------------------------------------------------------------------------
" DIFFING {{{
" ----------------------------------------------------------------------------

" Note this is += since fillchars was defined in the window config
set fillchars+=diff:⣿
set diffopt=vertical                  " Use in vertical diff mode
set diffopt+=filler                   " blank lines to keep sides aligned
set diffopt+=iwhite                   " Ignore whitespace changes
"}}}
" ----------------------------------------------------------------------------
"             FORMAT OPTIONS {{{
" ----------------------------------------------------------------------------
" Input auto-formatting (global defaults)
" Probably need to update these in after/ftplugin too since ftplugins will
" probably update it.
set formatoptions=
set formatoptions+=1
set formatoptions-=q                  " continue comments with gq"
set formatoptions-=c                  " Auto-wrap comments using textwidth
set formatoptions-=r                  " Do not continue comments by default
set formatoptions-=o                  " do not continue comment using o or O
set formatoptions+=n                  " Recognize numbered lists
set formatoptions+=2                  " Use indent from 2nd line of a paragraph
if v:version > 703 || v:version == 703 && has('patch541')
  set formatoptions+=j
endif
set nrformats-=octal " never use octal when <C-x> or <C-a>"
"}}}
" ----------------------------------------------------------------------------
" Vim Path
" ----------------------------------------------------------------------------
" set path+=** "Vim searches recursively through all directories and subdirectories
set path+=**/src/main/**,** " path set to some greedy globs and suffixesadd set to contain .js. This allows me to press gf (open file under cursor) on a require statement, and it will actually take me to the source (if it exists)
set suffixesadd+=.js
" set autochdir

" ----------------------------------------------------------------------------
" Wild and file globbing stuff in command mode {{{
" ----------------------------------------------------------------------------
" Use faster grep alternatives if possible
if executable('rg')
  " set grepprg=rg\ --vimgrep\ --no-heading
  set grepprg=rg\ --smart-case\ --vimgrep\ $*
  set grepformat^=%f:%l:%c:%m
elseif executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor\ --vimgrep
  set grepformat^=%f:%l:%c:%m
endif

"pressing Tab on the command line will show a menu to complete buffer and file names
set wildchar=<Tab>
set wildmenu
set wildmode=full       " Shows a menu bar as opposed to an enormous list
set wildcharm=<C-Z>
nnoremap <leader><tab> :b <C-Z>
set wildignorecase " Ignore case when completing file names and directories
" Binary
set wildignore+=*.aux,*.out,*.toc
set wildignore+=*.o,*.obj,*.exe,*.dll,*.jar,*.pyc,*.rbc,*.class
set wildignore+=*.ai,*.bmp,*.gif,*.ico,*.jpg,*.jpeg,*.png,*.psd,*.webp
set wildignore+=*.avi,*.m4a,*.mp3,*.oga,*.ogg,*.wav,*.webm
set wildignore+=*.eot,*.otf,*.ttf,*.woff
set wildignore+=*.doc,*.pdf
set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz
" Cache
set wildignore+=.sass-cache
set wildignore+=*/vendor/gems/*,*/vendor/cache/*,*/.bundle/*,*.gem
" Temp/System
set wildignore+=*.*~,*~
set wildignore+=*.swp,.lock,.DS_Store,._*,tags.lock

"}}}
" ----------------------------------------------------------------------------
" Display {{{
" --------------------------------------------------------------------------
" syntax sync minlines=256 " update syntax highlighting for more lines increased scrolling performance
" set synmaxcol=1024 " don't syntax highlight long lines
set emoji
if has('linebreak') "Causes wrapped line to keep same indentation
  " This should cause lines to wrap around words rather than random characters
  set linebreak
  " let &showbreak='↳ ' " DOWNWARDS ARROW WITH TIP RIGHTWARDS (U+21B3, UTF-8: E2 86 B3)
  let &showbreak='↪ '
  if exists('&breakindentopt')
    set breakindentopt=shift:2
  endif
endif

" LIST =============================================================
set list                              " show invisible chars
set listchars+=tab:▷\ 
set listchars+=precedes:←
set listchars+=extends:→
set listchars+=trail:•                " BULLET (U+2022, UTF-8: E2 80 A2)
set listchars+=eol:\ 
" =====================================================================
"-----------------------------------
" highlight MatchParen  guibg=#658494 gui=bold "Match parentheses Coloring
if has('unnamed')
  set clipboard=unnamed,unnamedplus
endif
set nojoinspaces                      " don't autoinsert two spaces after '.', '?', '!' for join command
set magic " For regular expressions turn magic on
set gdefault "Makes the g flag available by default so it doesn't have to be specified
" insert completion height and options
set pumheight=10
set completeopt-=preview " This prevents a scratch buffer from being opened
set title                             " wintitle = filename - vim
" set ttyfast " Improves smoothness of redrawing when there are multiple windows
if has('+relativenumber') "Add relative line numbers and relative = absolute line numbers i.e current
  set relativenumber
endif
set number
set linespace=4
set numberwidth=5
set report=0 " Always show # number yanked/deleted lines
set smartindent "Turns on smart indent which can help indent files like html natively
set wrap
set textwidth=79
set nojoinspaces "Use one space, not two, after punctuation
set autowrite "Automatically :write before running commands
set backspace=2 "Back space deletes like most programs in insert mode
if has('vim')
  if has('+signcolumn')
    set signcolumn=yes "enables column that shows signs and error symbols
  endif
endif
set ruler
set incsearch
set lazyredraw " Turns on lazyredraw which postpones redrawing for macros and command execution
if exists('&belloff')
  set belloff=all                     " never ring the bell for any reason
endif
if has('termguicolors') && $TERM_PROGRAM ==# 'iTerm.app' " Don't need this in xterm-256color, but do need it inside tmux. (See `:h xterm-true-color`.)
  set termguicolors " set vim-specific sequences for rgb colors super important for truecolor support in vim
  " if &term =~# 'tmux-256color' "Setting the t_ variables is a further step to ensure 24bit colors
  let &t_8f="\<esc>[38;2;%lu;%lu;%lum"
  let &t_8b="\<esc>[48;2;%lu;%lu;%lum"
  " endif
endif
set scrolljump=5
"}}}
" ----------------------------------------------------------------------------

" ------------------------------------
" Command line
" ------------------------------------
set showcmd "Show commands being input
set cmdheight=2 " Set command line height to two lines
"-----------------------------------------------------------------
"Abbreviations
"-----------------------------------------------------------------
iabbrev w@ www.akin-sowemimo.com

"fugitive plugin
let g:EditorConfig_core_mode = 'external_command' " Speed up editorconfig plugin
let g:EditorConfig_exclude_patterns = ['fugitive://.*']

"-----------------------------------------------------------
"Plugin configurations "{{{
"-----------------------------------------------------------------
let g:tagbar_autofocus = 1
let g:tagbar_type_css = {
      \ 'ctagstype' : 'Css',
      \ 'kinds'     : [
      \ 'c:classes',
      \ 's:selectors',
      \ 'i:identities'
      \ ]
      \ }
let g:neoformat_html_jsbeautify = {
      \ 'exe': 'htmlbeautify',
      \ 'args': [],
      \ 'stdin': 1,
      \ }
let g:neoformat_enabled_html = ['htmlbeautify']

let g:neoformat_css_jsbeautify = {
      \ 'exe': 'cssbeautify',
      \ 'stdin': 1,
      \ }
let g:neoformat_enabled_css = ['cssbeautify']

let g:neoformat_try_formatprg = 1 " Use formatprg when available
let g:neoformat_basic_format_trim = 1 " Enable trimmming of trailing whitespace
let g:neoformat_only_msg_on_error = 1

let g:vimsyn_folding          = 'af'
let g:fastfold_skip_filetypes = [ 'taglist' ]

" nmap <F4> :Gitv<CR>

let g:ycm_seed_identifiers_with_syntax        = 1
let g:ycm_collect_identifiers_from_tags_files = 1

let g:tern_show_argument_hints                = 'on_hold'
let g:tern_map_keys                           = 1
let g:tern_show_signature_in_pum              = 1
let g:vim_markdown_folding_disabled           = 1 " Stop folding markdown please

let g:github_dashboard = {
      \'username': 'Akin909',
      \'password': $GITHUB_TOKEN
      \}
nnoremap <F1> :GHDashboard! Akin909<CR>
"------------------------------------
" Goyo
"------------------------------------
let g:goyo_width=100
let g:goyo_margin_top = 2
let g:goyo_margin_bottom = 2
nnoremap <F3> :Goyo<CR>
function! s:goyo_enter()
  silent !tmux set status off
  silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
  set noshowmode
  set noshowcmd
  set nonumber
  set scrolloff=999
endfunction

function! s:goyo_leave()
  silent !tmux set status on
  silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
  set showmode
  set showcmd
  set number
  set relativenumber
  set scrolloff=5
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

" Goyo
function! s:auto_goyo()
  if &ft == 'markdown' && winnr('$') == 1
    Goyo 100
  elseif exists('#goyo')
    Goyo!
  endif
endfunction

function! s:goyo_markdown_leave()
  if winnr('$') < 2
    silent! :q
  endif
endfunction

"Not Working as intended at the moment as ?Loading Ultisnips on opening
"insert mode cancels goyo
augroup goyo_markdown
  autocmd!
  autocmd BufNewFile,BufRead * call s:auto_goyo()
  autocmd! User GoyoLeave nested call s:goyo_leave()
augroup END

let g:vim_markdown_fenced_languages =['css', 'erb=eruby', 'javascript', 'js=javascript', 'json=json', 'ruby', 'sass', 'scss=sass', 'xml', 'html', 'python', 'stylus=css', 'less=css', 'sql']
let g:vim_markdown_toml_frontmatter = 1

let g:UltiSnipsSnippetDirectories=["UltiSnips", "mySnippets"]
let g:UltiSnipsExpandTrigger="<C-J>"
let g:UltiSnipsJumpForwardTrigger="<C-J>"
let g:UltiSnipsListSnippets="<s-tab>"
let g:UltiSnipsJumpBackwardTrigger="<C-K>"
let g:UltiSnipsEditSplit="vertical" "If you want :UltiSnipsEdit to split your window.

" let g:livedown_autorun = 1 " should markdown preview get shown automatically upon opening markdown buffer
let g:livedown_open = 1 " should the browser window pop-up upon previewing
let g:livedown_port = 1337 " the port on which Livedown server will run
let delimitMate_expand_cr          = 2
let delimitMate_expand_space       = 1
" let delimitMate_jump_expansion     = 1
let delimitMate_balance_matchpairs = 1
" ================================================
" FZF
" ================================================
nnoremap <localleader>m  :Marks<CR>
nnoremap <localleader>mm :Maps<CR>

let g:fzf_action = {
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-s': 'split',
      \ 'ctrl-v': 'vsplit' }

" Customize fzf colors to match your color scheme
let g:fzf_colors =
      \ { 'fg':      ['fg', 'Normal'],
      \ 'bg':      ['bg', 'Normal'],
      \ 'hl':      ['fg', 'Comment'],
      \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
      \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
      \ 'hl+':     ['fg', 'Statement'],
      \ 'info':    ['fg', 'PreProc'],
      \ 'prompt':  ['fg', 'Conditional'],
      \ 'pointer': ['fg', 'Exception'],
      \ 'marker':  ['fg', 'Keyword'],
      \ 'spinner': ['fg', 'Label'],
      \ 'header':  ['fg', 'Comment'] }


"This  function makes FZF start from the root of a git dir
function! s:find_root()
  for vcs in ['.git', '.svn', '.hg']
    let dir = finddir(vcs.'/..', ';')
    if !empty(dir)
      execute 'Files' dir
      return
    endif
  endfor
  FZF
endfunction

command! FZFR call s:find_root()

"JS Docs plugin
let g:jsdoc_allow_input_prompt = 1
let g:jsdoc_input_description = 1
let g:jsdoc_enable_es6 = 1
nmap <silent> co <Plug>(jsdoc)

let g:vimjs#smartcomplete = 1 " Disabled by default. Enabling this will let vim complete matches at any location e.g. typing 'document' will suggest 'document' if enabled.
let g:vimjs#chromeapis = 1 " Disabled by default. Toggling this will enable completion for a number of Chrome's JavaScript extension APIs

if exists('NERDTree') " after a re-source, fix syntax matching issues (concealing brackets):
  if exists('g:loaded_webdevicons')
    call webdevicons#refresh()
  endif
endif

let g:startify_list_order = [
      \ ['   😇 My Sessions:'],
      \ 'sessions',
      \ ['   MRU Files:'],
      \ 'files',
      \ ['   MRU files in current directory:'],
      \ 'dir',
      \ ['   My Bookmarks:'],
      \ 'bookmarks',
      \ ['   Commands:'],
      \ 'commands',
      \ ]

let g:startify_session_dir = '~/.vim/session'
let g:startify_session_autoload = 1
let g:startify_session_persistence = 1
let g:startify_change_to_vcs_root = 1
let g:startify_session_sort = 1

" =========================================================================

"This sets default mapping for camel case text object
call camelcasemotion#CreateMotionMappings('<leader>')
"   Disable tmux navigator when zooming the Vim pane
let g:tmux_navigator_disable_when_zoomed = 1
"   saves on moving pane but only the currently opened buffer if changed
let g:tmux_navigator_save_on_switch = 2

"Remaps native insert mode paste binding to alt-p
inoremap ð <C-R>0
inoremap … <C-R><C-P>0

"}}}
""""""""""""""""""""""""""""""""""""""""""""""""""
" => HELPER FUNCTIONS
""""""""""""""""""""""""""""""""""""""""""""""""""
" See http://stackoverflow.com/questions/4064651/what-is-the-best-way-to-do-smooth-scrolling-in-vim
fun! s:smoothScroll(up)
  execute "normal " . (a:up ? "\<c-y>" : "\<c-e>")
  redraw
  for l:count in range(3, &scroll, 2)
    sleep 10m
    execute "normal " . (a:up ? "\<c-y>" : "\<c-e>")
    redraw
  endfor
endf
nnoremap <silent> <c-u> :call <sid>smoothScroll(1)<cr>
nnoremap <silent> <c-d> :call <sid>smoothScroll(0)<cr>

" for better tab response for emmet
" function! s:emmet_html_tab()
"   let line = getline('.')
"   if match(line, '<.*>') >= 0
"     return "\<c-y>n"
"   endif
"   return "\<c-y>"
" endfunction

" Function to use f to search backwards and forwards courtesy of help docs
" [WIP] see section H getpwd()
" function FindChar()
"   let c = nr2char(getchar())
"   while col('.') < col('$') - 1
"     normal l
"     if getline('.')[col('.') - 1] ==? c
"       break
"     endif
"   endwhile
" endfunction

function! WrapForTmux(s)
  if !exists('$TMUX')
    return a:s
  endif

  let tmux_start = "\<Esc>Ptmux;"
  let tmux_end = "\<Esc>\\"

  return tmux_start . substitute(a:s, "\<Esc>", "\<Esc>\<Esc>", 'g') . tmux_end
endfunction

let &t_SI .= WrapForTmux("\<Esc>[?2004h")
let &t_EI .= WrapForTmux("\<Esc>[?2004l")

function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

"Currently stalls vim!!!
function! VisualSelection(direction, extra_filter) range
  let l:saved_reg = @"
  execute "normal! vgvy"

  let l:pattern = escape(@", '\\/.*$^~[]')
  let l:pattern = substitute(l:pattern, "\n$", "", "")

  if a:direction == 'b'
    execute "normal ?" . l:pattern . "^M"
  elseif a:direction == 'f'
    execute "normal /" . l:pattern . "^M"
  endif

  let @/ = l:pattern
  let @" = l:saved_reg
endfunction
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
" vnoremap <silent> * :call VisualSelection('f', '')<CR>
" vnoremap <silent> # :call VisualSelection('b', '')<CR>

" NERDTrees File highlighting
function! NERDTreeHighlightFile(extension, fg, bg, guifg)
  exec 'autocmd FileType nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guifg='. a:guifg
  exec 'autocmd FileType nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
endfunction

call NERDTreeHighlightFile('html', 202, 'none', '#FC4709')
call NERDTreeHighlightFile('hbs', 202, 'none', '#FC4709')
call NERDTreeHighlightFile('jade', 149, 'none', '#A0D24D')
call NERDTreeHighlightFile('json', 223, 'none', '#FECEA0')
call NERDTreeHighlightFile('scss', 44, 'none', '#db7093')
call NERDTreeHighlightFile('css', 44, 'none', '#db7093')
call NERDTreeHighlightFile('js', 226, 'none', '#FFD700')
call NERDTreeHighlightFile('rb', 197, 'none', '#E53378')
call NERDTreeHighlightFile('md', 208, 'none', '#FD720A')
call NERDTreeHighlightFile('php', 140, 'none', '#9E6FCD')
call NERDTreeHighlightFile('svg', 178, 'none', '#CDA109')
call NERDTreeHighlightFile('gif', 36, 'none', '#15A274')
call NERDTreeHighlightFile('jpg', 36, 'none', '#15A274')
call NERDTreeHighlightFile('png', 36, 'none', '#15A274')
"-----------------------------------------------------------
"Colorscheme
"-----------------------------------------------------------
"Set color Scheme
set background=dark
colorscheme quantum
" let g:one_allow_italics = 1
nnoremap <silent><F9> :exec "color " .
      \((g:colors_name=="quantum") ?"one":"quantum")<CR>
" if g:colors_name=="one"
"   call one#highlight('Normal', '', '203038', 'none')
"   call one#highlight('Cursorline','', '273B45', 'none')
"   call one#highlight('FoldColumn', '', '', 'none')
"   call one#highlight('PmenuSel', '', '203038', 'none')
"   call one#highlight('PmenuSbar', '', '203038', 'none')
" endif

if &term =~ '256color'
  " disable Background Color Erase (BCE) so that color schemes
  " render properly when inside 256-color tmux and GNU screen.
  set t_ut=
endif
" Comments in ITALICS YASSSSS!!!
hi Comment cterm=italic
hi clear Conceal "Sets no highlighting for conceal
hi Folded guifg=#FFC66D guibg=NONE
set conceallevel=2
"---------------------------------------------------------------------
" Utilities
"---------------------------------------------------------------------
set noshowmode "No mode showing in command pane
set updatetime=2000
if has('virtualedit')
  set virtualedit=block               " allow cursor to move where there is no text in visual block mode
endif
" ----------------------------------------------------------------------------
" Tabbing - overridden by editorconfig, after/ftplugin {{{
" ----------------------------------------------------------------------------
set expandtab                         " default to spaces instead of tabs
set shiftwidth=2                      " softtabs are 2 spaces for expandtab
set softtabstop=-2 " Alignment tabs are two spaces, and never tabs. Negative means use same as shiftwidth (so the 2 actually doesn't matter).
set tabstop=8 " real tabs render width. Applicable to HTML, PHP, anything using real tabs. I.e., not applicable to JS.
set noshiftround " use multiple of shiftwidth when shifting indent levels. this is OFF so block comments don't get fudged when using \">>" and \"<<"
set smarttab " When on, a <Tab> in front of a line inserts blanks according to 'shiftwidth'. 'tabstop' or 'softtabstop' is used in other places.
" set complete+=k " Add dictionary to vim's autocompletion
if !has('nvim')
  set complete-=i
  set autoindent
endif
" Use <C-I> to clear the highlighting of :set hlsearch.
" if maparg('<C-I>', 'n') ==# ''
"   nnoremap <silent> <C-I> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-I>
" endif
set display+=lastline
if &encoding ==# 'latin1' && has('gui_running')
  set encoding=utf-8
endif
scriptencoding utf-8

" =======================================================
"  DICTIONARY
" =======================================================
" set dictionary-=/usr/share/dict/words dictionary+=/usr/share/dict/words
if &shell =~# 'fish$' && (v:version < 704 || v:version == 704 && !has('patch276'))
  set shell=/bin/bash
endif
set autoread " reload files if they were edited elsewhere

set history=100
if &tabpagemax < 50
  set tabpagemax=50
endif
if !empty(&viminfo)
  set viminfo^=!
endif
set sessionoptions-=options
" Allow color schemes to do bright colors without forcing bold.
if &t_Co == 8 && $TERM !~# '^linux\|^Eterm'
  set t_Co=16
endif
"-----------------------------------------------------------------------------
" BACKUP AND SWAPS
"-----------------------------------------------------------------------------
"Turn swap files off - FOR GOD's SAKE they are ruining my life
set noswapfile
"This saves all back up files in a vim backup directory
if exists('$SUDO_USER')
  set nobackup                        " don't create root-owned files
  set nowritebackup                   " don't create root-owned files
else
  set backupdir=~/.vim/.backup//
  set backupdir+=~/local/.vim/tmp/backup
  set backupdir+=~/.vim/tmp/backup    " keep backup files out of the way
endif

" set directory=~/.vim/.swp//
if has ('persistent_undo')
  if exists('$SUDO_USER')
    set noundofile "Dont add root owned files which I will need to sudo to remove
  else
    set undodir=~/.vim/.undo//
    set undodir+=~/local/.vim/tmp/undo
    set undodir+=.
    set undofile
  endif
endif

if has("vms") 
  set nobackup 
else
  set backup 
endif
"}}}
" ----------------------------------------------------------------------------
" Match and search
" ----------------------------------------------------------------------------
" hi Search guibg=LightGreen  ctermbg=NONE
" Sets a case insensitive search except when using Caps
set ignorecase
set smartcase
set wrapscan " Searches wrap around the end of the file
set nohlsearch " -functionality i.e. search highlighting done by easy motion and incsearch
if &ft ==# 'html'
  set matchpairs+=<:> "setting is super annoying if not html
endif

" ----------------------------------------------------------------------------
" CURSOR  "{{{
" ----------------------------------------------------------------------------
" Set cursorline to the focused window only and change and previously color/styling of cursor line depending on mode - Slow?
" augroup cursorline
"   autocmd!
"   autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
"   autocmd WinLeave * setlocal nocursorline
" augroup END

set scrolloff=20 " Show context around current cursor position i.e. cursor lines remaining whilst moving up or down As this is set to a large number the cursor will remain in the middle of the page on scroll (8 ) was the previous value
set sidescrolloff=10
set nostartofline " Stops some cursor movements from jumping to the start of a line

"}}}
" ----------------------------------------------------------------------------
"-----------------------------------------------------------------------------------
"DIY STATUS LINE ==========================={{{
" =====================================================================
" stolen from https://gabri.me/blog/diy-vim-statusline
" =====================================================================
 " Dynamically getting the fg/bg colors from the current colorscheme, returns hex 
" set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids

  let g:ro_sym  = ''
  let g:ma_sym  = "✗"
  let g:mod_sym = "◇"
  let g:ff_map  = { "unix": "␊", "mac": "␍", "dos": "␍␊" }
let g:currentmode={
    \ 'n'  : 'Normal ',
    \ 'no' : 'N·Operator Pending ',
    \ 'v'  : 'Visual ',
    \ 'V'  : 'V·Line ',
    \ '' : 'V·Block ',
    \ 's'  : 'Select ',
    \ 'S'  : 'S·Line ',
    \ '^S' : 'S·Block ',
    \ 'i'  : 'Insert ',
    \ 'R'  : 'Replace ',
    \ 'Rv' : 'V·Replace ',
    \ 'c'  : 'Command ',
    \ 'cv' : 'Vim Ex ',
    \ 'ce' : 'Ex ',
    \ 'r'  : 'Prompt ',
    \ 'rm' : 'More ',
    \ 'r?' : 'Confirm ',
    \ '!'  : 'Shell ',
    \ 't'  : 'Terminal '
    \}

" Automatically change the statusline color depending on mode - requires gui colors as using termguicolors
function! ChangeStatuslineColor()
  if (mode() =~# '\v(n|no)')
    exe 'hi! StatusLine guibg=#425762'
  elseif (mode() =~# '\v(v|V)' || g:currentmode[mode()] ==# 'V·Block' || get(g:currentmode, mode(), '') ==# 't')
    exe 'hi! StatusLine guibg=#5f5fd7'
  elseif (mode() ==# 'i')
    exe 'hi! StatusLine guibg=#005f87'
  else
    exe 'hi! StatusLine guibg=#005faf'
  endif
  return ''
endfunction

" Find out current buffer's size and output it.
function! FileSize()
  let bytes = getfsize(expand('%:p'))
  if (bytes >= 1024)
    let kbytes = bytes / 1024
  endif
  if (exists('kbytes') && kbytes >= 1000)
    let mbytes = kbytes / 1000
  endif

  if bytes <= 0
    return '0'
  endif

  if (exists('mbytes'))
    return mbytes . 'MB '
  elseif (exists('kbytes'))
    return kbytes . 'KB '
  else
    return bytes . 'B '
  endif
endfunction

function! ReadOnly()
  if &readonly || !&modifiable
    return ''
  elseif &modified
    return g:mod_sym
  else
    return ''
endfunction

function! GitInfo()
  let git = fugitive#head()
  if git != ''
    return ' '.fugitive#head()
  else
    return ''
  endfunction

" Returns true if paste mode is enabled
function! HasPaste()
  if &paste
    exe 'hi! StatusLine guibg=#00875f'
    return 'PASTE MODE  '
  endif
  return ''
endfunction

" Determine the name of the session or terminal
if (strlen(v:servername)>0)
  if v:servername =~ 'nvim'
    let g:session = 'neovim'
  else
    " If running a GUI vim with servername, then use that
    let g:session = v:servername
  endif
elseif !has('gui_running')
  " If running CLI vim say TMUX or use the terminal name.
  if (exists("$TMUX"))
    let g:session = 'Tmux'
  else
    " Giving preference to color-term because that might be more
    " meaningful in graphical environments. Eg. my $TERM is
    " usually screen256-color 90% of the time.
    let g:session = exists("$COLORTERM") ? $COLORTERM : $TERM
  endif
else
  " idk, my bff jill
  let g:session = 'NARNIA'
endif

" Shamelessly stolen from statline plugin, shows buffer count and buffer number
" function! BufCount()
"   if !exists("s:statline_n_buffers")
"     let s:statline_n_buffers = len(filter(range(1,bufnr('$')), 'buflisted(v:val)'))
"   endif
"   return s:statline_n_buffers
" endfunction

" if !exists('g:statline_show_n_buffers')
"   let g:statline_show_n_buffers = 1
" endif

" Always display the status line even if only one window is displayed
set laststatus=2
set statusline=
set statusline+=%{ChangeStatuslineColor()}               " Changing the statusline color
set statusline+=\ %{toupper(g:currentmode[mode()])} " Current mode
" ---- number of buffers : buffer number ----
" if g:statline_show_n_buffers
"   set statusline+=\ %{BufCount()}\:%n\ %< " only calculate buffers after adding/removing buffers
"   augroup statline_nbuf
"     autocmd!
"     autocmd BufAdd,BufDelete * unlet! s:statline_n_buffers
"   augroup END
" else
"   set statusline=[%n]\ %<
" endif
" --------------------------------------------
set statusline+=\ %{HasPaste()}
set statusline+=\ %{g:session}
set statusline+=\ %{GitInfo()}
set statusline+=\ %<%.30F\ %w
set statusline+=%{ReadOnly()}\ 
set statusline+=%{exists('*CapsLockStatusline')?CapsLockStatusline():''}
set statusline+=%#warningmsg#
set statusline+=%*
set statusline+=\ %=                                     " Space
" set statusline+=%{synIDattr(synID(line('.'),col('.'),1),'name')}\  " highlight
set statusline+=\ %{&ft}\ %q\   " FileType & quick fix or loclist given as variable with '&' so nice and lowercase
set statusline+=%{get(g:ff_map,&ff,'?').(&expandtab?'\ ˽\ ':'\ ⇥\ ').&tabstop} "Get method finds the fileformat array and returns the matching key the &ff or ? expand tab shows whether i'm using spaces or tabs
set statusline+=\ %-3(%{FileSize()}%)                 " File size
set statusline+=\ %3p%%\ \ %l\ of\ %1L\                 " The numbers after the % represent degrees of padding
set statusline+=%{ale#statusline#Status()}\ 
"==============================================================
"Need to figure this our in order to change statusline colors
if has('termguicolors')
  "filename
  hi default link User1 Identifier
  " flags
  hi default link User2 Statement
  " errors
  hi default link User3 Error
  " fugitive
  hi default link User4 Special
endif
  " hi User8 ctermfg=008 " guifg=fgcolor
  " hi User9 ctermfg=007 " guifg=fgcolor
  " hi User5 guifg=Blue guibg=White
  " hi User7 guibg=#005faf
"==============================================================}}}
"MAPPINGS {{{
"-----------------------------------------------------------------------------------
nnoremap <silent><expr> <CR> empty(&buftype) ? '@@' : '<CR>'
"Evaluates whether there is a fold on the current line if so unfold it else return a normal space
nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
"Use this to ensure mappings dont already exist
" if !hasmapto('\ABCdoit')
"    map <Leader>d \ABCdoit
" endif
" Close all the buffers
nnoremap <leader>ba :1,1000 bd!<cr>
" Quickly edit your macros
" Usage <leader>m or "q<leader>m
nnoremap <leader>m  :<c-u><c-r>='let @'. v:register .' = '. string(getreg(v:register))<cr><c-f><left>
" Shortcuts
" Change Working Directory to that of the current file
cmap cwd lcd %:p:h
cmap cd. lcd %:p:h
" For when you forget to sudo.. Really Write the file.
cmap w!! w !sudo tee % >/dev/null

"""""""""""""""""""""""""""""""""""""""""""""""""""
" => VISUAL MODE RELATED
""""""""""""""""""""""""""""""""""""""""""""""""""
" ; and , search
" forward/backward regardless of the direction of the previous
" character search: doesn't work
" nnoremap <expr> : getcharsearch().forward ? ';' : ','
" nnoremap <expr> , getcharsearch().forward ? ',' : ';'
" Treat long lines as break lines (useful when moving around in them).
" Store relative line number jumps in the jumplist.
noremap <expr> j v:count > 1 ? 'm`' . v:count . 'j' : 'gj'
noremap <expr> k v:count > 1 ? 'm`' . v:count . 'k' : 'gk'

" Emacs like keybindings for the command line (:) are better
" and you cannot use Vi style-binding here anyway, because ESC
" just closes the command line and using Home and End..
" remap arrow keys
" c-a / c-e everywhere
cnoremap <C-A> <Home>
cnoremap <C-E> <End>
cnoremap <C-K> <C-U>
cnoremap <C-P> <Up>
cnoremap <C-N> <Down>

nnoremap <Leader>s :update<CR>
" Tab and Shift + Tab Circular buffer navigation
nnoremap <tab>   :bnext<CR>
nnoremap <S-tab> :bprevious<CR>
" nnoremap <CR> G "20 enter to go to line 20
nnoremap <BS> gg
"Change operator arguments to a character representing the desired motion
nnoremap ; :
nnoremap : ;

nnoremap [Alt]   <Nop>
xnoremap [Alt]   <Nop>
" nmap    e  [Alt]
" xmap    e  [Alt]
" Like gv, but select the last changed text.
nnoremap gi  `[v`]
" Specify the last changed text as {motion}.
onoremap <silent> gi  :<C-u>normal gc<CR>"`
vnoremap <silent> gi  :<C-u>normal gc<CR>
" Capitalize.
nnoremap õ <ESC>gUiw`]
inoremap <C-u> <ESC>gUiw`]a

" Smart }."
nnoremap <silent> } :<C-u>call ForwardParagraph()<CR>
onoremap <silent> } :<C-u>call ForwardParagraph()<CR>
xnoremap <silent> } <Esc>:<C-u>call ForwardParagraph()<CR>mzgv`z
function! ForwardParagraph()
  let cnt = v:count ? v:count : 1
  let i = 0
  while i < cnt
    if !search('^\s*\n.*\S','W')
      normal! G$
      return
    endif
    let i = i + 1
  endwhile
endfunction
" Select block.
xnoremap r <C-v>
" Made mappings recursize to work with targets plugin
" 'quote'
omap aq  a'
xmap aq  a'
omap iq  i'
xmap iq  i'

" \"double quote"
omap ad  a"
xmap ad  a"
omap id  i"
xmap id  i"

" <angle> 
" omap aa  a>
" xmap aa  a>
" omap ia  i>
" xmap ia  i>
"Change two horizontally split windows to vertical splits
nnoremap <LocalLeader>h <C-W>t <C-W>K
"Change two vertically split windows to horizontal splits
nnoremap <LocalLeader>v <C-W>t <C-W>H
"Select txt that has just been read or pasted in
nnoremap gV `[V`]

"Bubbling text a la vimcasts - http://vimcasts.org/episodes/bubbling-text/
" Better bubbling a la Tpope's unimpaired vim
nmap ë [e
nmap ê ]e
vmap ë [egv
vmap ê ]egv

"Line completion - native vim
inoremap ç <C-X><C-L>
" find visually selected text
vnoremap * y/<C-R>"<CR>
" replace word under cursor
nnoremap S :%s/\<<C-R><C-W>\>//gc<Left><Left><Left>
" make . work with visually selected lines
vnoremap . :norm.<CR>
inoremap ó <C-O>:update<CR>
"This mapping allows yanking all of a line without taking the new line
"character as well can be with our without spaces
vnoremap <silent> al :<c-u>norm!0v$h<cr>
vnoremap <silent> il :<c-u>norm!^vg_<cr>
onoremap <silent> al :norm val<cr>
onoremap <silent> il :norm vil<cr>
"ctrl-o in insert mode allows you to perform one normal mode command then
"returns to insert mode
" inoremap <C-j> <Down>
inoremap ê <Down>
inoremap è <left>
inoremap ë <up>
inoremap ì <right>
" select last paste in visual mode
nnoremap <expr> gb '`[' . strpart(getregtype(), 0, 1) . '`]'
nnoremap <F6> :! open %<CR>
set pastetoggle=<F2>
set timeout timeoutlen=500 ttimeoutlen=100 "time out on mapping after half a second, time out on key codes after a tenth of a second automatically at present
" Remap jumping to the last spot you were editing previously to bk as this is easier form me to remember
nnoremap bk `.
" Yank from the cursor to the end of the line, to be consistent with C and D.
nnoremap Y y$
nnoremap <leader>sw :b#<CR>
" Quick find/replace
nnoremap <Leader>[ :%s/<C-r><C-w>/
vnoremap <Leader>[ "zy:%s/<C-r><C-o>"/
"--------------------------------------------
"Absolutely fantastic function from stoeffel/.dotfiles which allows you to
"repeat macros across a visual range
"--------------------------------------------
xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>
function! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction
"--------------------------------------------

" Visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv
"Help Command - vertical split
command! -complete=help -nargs=1 H call VerticalHelp(<f-args>)
function! VerticalHelp(topic)
  execute "vertical botright help " . a:topic
  execute "vertical resize 78"
endfunction
"Remap back tick for jumping to marks more quickly
nnoremap ' `
nnoremap ` '

nnoremap rs ^d0
"Save all files
nnoremap qa :wqa<CR>
" clean up any trailing whitespace - neoformat does this
" nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<cr>
"open a new file in the same directory
nnoremap <Leader>nf :e <C-R>=expand("%:p:h") . "/" <CR>

nnoremap <localleader>c :<c-f>
"Open command line window
nnoremap <localleader>l :redraw!<cr>
"--------------------------------------------
" Window resizing bindings
"--------------------------------------------
"Create a horizontal split
nnoremap _ :sp<CR>
"Create a vertical split
nnoremap \| :vsp<CR>
" Resize window vertically  - shrink
nnoremap <down> 15<c-w>-
" Resize window vertically - grow
nnoremap <up> 15<c-w>+
" Increase window size horizontally
nnoremap <left> 15<c-w>>
" Decrease window size horizontally
nnoremap <right> 15<c-w><
" Max out the height of the current split
nnoremap <localleader>f <C-W>_
" Max out the width of the current split
nnoremap <localleader>e <C-W>|

"Normalize all split sizes, which is very handy when resizing terminal
nnoremap <leader>= <C-W>=
"Break out current window into new tabview
nnoremap <leader>t <C-W>T
"Close every window in the current tabview but the current one
nnoremap <localleader>q <C-W>o
"Swap top/bottom or left/right split
nnoremap <leader>r <C-W>R
"--------------------------------------------
"Open Common files
nnoremap <leader>ez :e ~/.zshrc<cr>
nnoremap <leader>et :e ~/.tmux.conf<cr>

nnoremap <leader>x :lclose<CR>
"Indent a page
nnoremap <C-G>f gg=G<CR>
" duplicate line and comment (requires vim-commentary)
nmap <leader>cc yygccp
xmap <leader>cc m'ygvgc''jp
"map window keys to leader - Interfere with tmux navigator
" noremap <C-h> <c-w>h
" noremap <C-j> <c-w>j
" noremap <C-k> <c-w>k
" noremap <C-l> <c-w>l
"Remap arrow keys to do nothing
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

"Moves cursor back to the start of a line
inoremap <C-B> <C-O>I
" Make Ctrl-e jump to the end of the current line in the insert mode. This is
" handy when you are in the middle of a line and would like to go to its end
" without switching to the normal mode.
" source : https://blog.petrzemek.net/2016/04/06/things-about-vim-i-wish-i-knew-earlier/
inoremap <C-e> <C-o>$
"Move to beginning of a line in insert mode
inoremap <c-a> <c-o>0
inoremap <c-e> <c-o>$
"Remaps native ctrl k - deleting to the end of a line to control e
" inoremap <C-Q> <C-K>
" Map jk to esc key - using jk prevents jump that using ii causes
" inoremap jk <ESC>:w<CR>
inoremap jk <ESC>
inoremap ;; <End>;<Esc>:w<CR>

" Yank text to the OS X clipboard
noremap <localleader>y "*y
noremap <localleader>yy "*Y
"Maps K and J to a 10 k and j but @= makes the motions multipliable - not
"a word I know
noremap K  @='10k'<CR>
noremap J  @='10j'<CR>

"This line opens the vimrc in a vertical split
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <localleader>ev :tabnew $MYVIMRC<cr>

"This line allows the current file to source the vimrc allowing me use bindings as they're added
nnoremap <leader>sv :source $MYVIMRC<cr>
"This maps leader quote (single or double to wrap the word in quotes)
nnoremap <leader>" viw<esc>a"<esc>bi"<esc>lel
nnoremap <leader>' viw<esc>a'<esc>bi'<esc>lel
" Remap going to beginning and end of lines
" move to beginning/end of line
nnoremap H ^
nnoremap L $

"Map Q to remove a CR
nnoremap Q J

"Add neovim terminal escape with ESC mapping
if has("nvim")
  tnoremap <ESC> <C-\><C-n>
endif
"}}}

