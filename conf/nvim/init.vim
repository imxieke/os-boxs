" 编辑器配置

" enable syntax  highlighting
syntax on
set hidden                                      " Required for operations modifying multiple buffers like rename.
set termguicolors " this variable must be enabled for colors to be applied properly
set background=dark     " dark theme
" set background=light  " light theme
colorscheme onedark
" 将制表符扩展为空格
set expandtab
" 开启文件类型侦测
filetype on
" 根据侦测到的不同类型加载对应的插件
filetype plugin on
filetype detect
set list
set modeline
set mouse=a                                     " enable mouse interaction
"开启增量搜索 
set incsearch ignorecase
" 搜索忽略大小写
set ignorecase smartcase
" highlight text while searching
set hlsearch
"显示行号
set number
"vim命令自动补全
set wildmenu
"显示光标位置
set ruler
set wrap                                        " wrap text 自动折行
set nobackup                                    " 设置取消备份 禁止临时文件生成
set fenc=utf-8                                  " 文件编码
set encoding=utf-8
" 突出显示当前行
set cursorline
" 突出显示当前列
set cursorcolumn
"禁用vi兼容模式
set nocompatible
"总是显示状态栏
set laststatus=2
set smartcase
set autoindent smartindent                      " enable indentation
"文件自动更新
set autoread
" 制表符占用空格数
set tabstop=4
" 设置格式化时制表符占用空格数
set shiftwidth=4
" 让 vim 把连续数量的空格视为一个制表符
set softtabstop=4
set emoji                                       " enable emojis
set history=1000                                " history limit
set title                                       " tab title as file name

" Interface
set showcmd
" 高亮匹配括号
set showmatch
"指定配色方案为256
set t_Co=256
set helplang=cn
hi Normal ctermfg=252 ctermbg=none "背景透明

call plug#begin('~/.config/nvim/plugged')

" Plugin
Plug 'nvim-lua/plenary.nvim'
Plug 'glepnir/dashboard-nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'junegunn/vim-easy-align'
Plug 'ryanoasis/vim-devicons' "Icons without colours
Plug 'kyazdani42/nvim-web-devicons' " Recommended (for coloured icons)
let g:nvim_tree_gitignore = 1 "0 by default
let g:nvim_tree_quit_on_open = 1 "0 by default, closes the tree when you open a file
let g:nvim_tree_indent_markers = 1 "0 by default, this option shows indent markers when folders are open
let g:nvim_tree_git_hl = 1 "0 by default, will enable file highlight for git attributes (can be used without the icons).
let g:nvim_tree_highlight_opened_files = 1 "0 by default, will enable folder and file icon highlight for opened files/directories.
let g:nvim_tree_root_folder_modifier = ':~' "This is the default. See :help filename-modifiers for more options
let g:nvim_tree_add_trailing = 1 "0 by default, append a trailing slash to folder names
let g:nvim_tree_group_empty = 1 " 0 by default, compact folders that only contain a single folder into one node in the file tree
let g:nvim_tree_disable_window_picker = 1 "0 by default, will disable the window picker.
let g:nvim_tree_icon_padding = ' ' "one space by default, used for rendering the space between the icon and the filename. Use with caution, it could break rendering if you set an empty string depending on your font.
let g:nvim_tree_symlink_arrow = ' >> ' " defaults to ' ➛ '. used as a separator between symlinks' source and target.
let g:nvim_tree_respect_buf_cwd = 1 "0 by default, will change cwd of nvim-tree to that of new buffer's when opening nvim-tree.
let g:nvim_tree_create_in_closed_folder = 0 "1 by default, When creating files, sets the path of a file when cursor is on a closed folder to the parent folder when 0, and inside the folder when 1.
let g:nvim_tree_refresh_wait = 500 "1000 by default, control how often the tree can be refreshed, 1000 means the tree can be refresh once per 1000ms.
let g:nvim_tree_window_picker_exclude = {
    \   'filetype': [
    \     'notify',
    \     'packer',
    \     'qf'
    \   ],
    \   'buftype': [
    \     'terminal'
    \   ]
    \ }
" Dictionary of buffer option names mapped to a list of option values that
" indicates to the window picker that the buffer's window should not be
" selectable.

let g:nvim_tree_special_files = { 'README.md': 1, 'Makefile': 1, 'MAKEFILE': 1 } " List of filenames that gets highlighted with NvimTreeSpecialFile
let g:nvim_tree_show_icons = {
    \ 'git': 1,
    \ 'folders': 0,
    \ 'files': 0,
    \ 'folder_arrows': 0,
    \ }
"If 0, do not show the icons for one of 'git' 'folder' and 'files'
"1 by default, notice that if 'files' is 1, it will only display
"if nvim-web-devicons is installed and on your runtimepath.
"if folder is 1, you can also tell folder_arrows 1 to show small arrows next to the folder icons.
"but this will not work when you set indent_markers (because of UI conflict)

" default will show icon by default if no icon is provided
" default shows no icon by default
let g:nvim_tree_icons = {
    \ 'default': '',
    \ 'symlink': '',
    \ 'git': {
    \   'unstaged': "✗",
    \   'staged': "✓",
    \   'unmerged': "",
    \   'renamed': "➜",
    \   'untracked': "★",
    \   'deleted': "",
    \   'ignored': "◌"
    \   },
    \ 'folder': {
    \   'arrow_open': "",
    \   'arrow_closed': "",
    \   'default': "",
    \   'open': "",
    \   'empty': "",
    \   'empty_open': "",
    \   'symlink': "",
    \   'symlink_open': "",
    \   }
    \ }

nnoremap <C-n> :NvimTreeToggle<CR>
nnoremap <leader>r :NvimTreeRefresh<CR>
nnoremap <leader>n :NvimTreeFindFile<CR>
" NvimTreeOpen, NvimTreeClose, NvimTreeFocus, NvimTreeFindFileToggle, and NvimTreeResize are also available if you need them

" a list of groups can be found at `:help nvim_tree_highlight`
highlight NvimTreeFolderIcon guibg=blue
Plug 'kyazdani42/nvim-tree.lua'
" Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nathanaelkane/vim-indent-guides'
Plug 'itchyny/vim-cursorword'
Plug 'vim-scripts/indentpython.vim'
" 文件模糊搜索
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
" 代码格式整理
Plug 'Chiel92/vim-autoformat'

"IDE启动界面
Plug 'mhinz/vim-startify'

" Docker development plugin for Vim
Plug 'danishprakash/vim-docker'

" 🌵 Viewer & Finder for LSP symbols and tags
Plug 'liuchengxu/vista.vim'
" A light and configurable statusline/tabline plugin for Vim
Plug 'itchyny/lightline.vim'
" lua `fork` of vim-web-devicons for neovim
Plug 'kyazdani42/nvim-web-devicons'

" yabai,ubersicht,simple-bar combination for myself
Plug 'ulwlu/elly-simple-bar'
" A tree explorer plugin for vim
Plug 'preservim/nerdtree'
" Adds file type icons to Vim plugins such as: NERDTree, vim-airline, CtrlP, unite, Denite, lightline, vim-startify and many more
Plug 'ryanoasis/vim-devicons'
" 📁 Powerful file explorer implemented by Vim script
Plug 'Shougo/vimfiler.vim'
" vimfiler will be used as the default explorer (instead of netrw.)
" :let g:vimfiler_as_default_explorer = 1
" IDE-like Vim tabline
Plug 'bagrat/vim-buffet'
" 🔄 Async Vim/Neovim plugin for showing the number of your outdated plugins
Plug 'semanser/vim-outdated-plugins'
" Do not show any message if all plugins are up to date. 0 by default
let g:outdated_plugins_silent_mode = 1
" 🌷 Vim plugin that shows keybindings in popup On-demand lazy load
Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey', 'WhichKey!'] }
" An efficient fuzzy finder that helps to locate files, buffers, mrus, gtags, etc. on the fly for both vim and neovim.
Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' }
" 👏 Modern performant generic finder and dispatcher for Vim and NeoVim
Plug 'liuchengxu/vim-clap'
" Change the CamelCase of related highlight group name to under_score_case.
let g:clap_theme = { 'search_text': {'guifg': 'red', 'ctermfg': 'red'} }
" experimental quick picker for vim
Plug 'prabirshrestha/quickpick.vim'
" filetype picker for quickpick.vim
Plug 'prabirshrestha/quickpick-filetypes.vim'
" Colorscheme picker for quickpick.vim
Plug 'prabirshrestha/quickpick-colorschemes.vim'
" Check syntax in Vim asynchronously and fix files, with Language Server Protocol (LSP) support
" Plug 'dense-analysis/ale'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'mhinz/vim-signify'

" Syntax
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'
" Snippets are separated from the engine. Add this if you want them:
" vim-snipmate default snippets (Previously snipmate-snippets)
Plug 'honza/vim-snippets'
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

Plug 'hail2u/vim-css3-syntax'
Plug 'dart-lang/dart-vim-plugin'
" Go development plugin for Vim
Plug 'fatih/vim-go'
" Kotlin plugin for Vim. Featuring: syntax highlighting, basic indentation, Syntastic support
Plug 'udalov/kotlin-vim'
" Enhanced javascript syntax file for Vim
Plug 'jelera/vim-javascript-syntax'
" Vastly improved Javascript indentation and syntax support in Vim
Plug 'pangloss/vim-javascript'
" Improved nginx vim plugin (incl. syntax highlighting)
Plug 'chr4/nginx.vim'
" Vim syntax file & snippets for Docker's Dockerfile
Plug 'ekalinin/Dockerfile.vim'
" Use FriendsOfPHP/PHP-CS-Fixer
Plug 'stephpy/vim-php-cs-fixer'
" An up-to-date Vim syntax for PHP (7.x supported)
Plug 'StanAngeloff/php.vim'
" Vim support for Composer PHP projects
Plug 'noahfrederick/vim-composer'
" Vim support for Laravel/Lumen projects
Plug 'noahfrederick/vim-laravel'
" dispatch.vim: Asynchronous build and test dispatcher
Plug 'tpope/vim-dispatch'
" projectionist.vim: Granular project configuration
Plug 'tpope/vim-projectionist'
" jdaddy.vim: JSON manipulation and pretty printing
Plug 'tpope/vim-jdaddy'
" Vim plugin that lets you navigate JSON documents using dot.notation.paths
Plug 'mogelbrod/vim-jsonpath'
" Vim syntax and indent plugin for vue files
Plug 'leafOfTree/vim-vue-plugin'
Plug 'skanehira/docker-compose.vim'
" An up-to-date jinja2 syntax file.
Plug 'Glench/Vim-Jinja2-Syntax'
" Laravel Blade Template
Plug 'jwalton512/vim-blade'
" Yet Another TypeScript Syntax The most advanced TypeScript Syntax Highlighting in Vim
Plug 'HerringtonDarkholme/yats.vim'
" Ember.js ES6 snippets for vim using UltiSnips format
Plug 'josemarluedke/ember-vim-snippets'
" Edit Bash scripts in Vim/gVim. Insert code snippets, run, check, and debug the code and look up help.
Plug 'WolfgangMehner/bash-support'
" Plug 'shawncplus/phpcomplete.vim'
" Edit LaTeX documents in Vim/gVim/Neovim. Insert commands, run the typesetter and BibTeX and look up help.
Plug 'WolfgangMehner/latex-support'
" Edit Lua scripts in Vim/gVim/Neovim. Insert code snippets, run, compile, and check the code and look up help
Plug 'WolfgangMehner/lua-support'
" Edit VimL scripts in Vim/gVim/Neovim. Insert code snippets, quickly comment the code and look up help.
Plug 'WolfgangMehner/vim-support'
" Edit AWK scripts in Vim/gVim. Insert code snippets, run, and check the code and look up help.
Plug 'WolfgangMehner/awk-support'
" Edit C/C++ programs in Vim/gVim. Insert code snippets, compile the code, run Make/CMake/... and look up help.
" Plug 'WolfgangMehner/c-support'
" lean & mean status/tabline for vim that's light as air
Plug 'vim-airline/vim-airline'
" Plug 'vim-airline/vim-airline-themes'
" Show battery information on statusline/tabline of Neovim/Vim
Plug 'lambdalisue/battery.vim'
" A Filetype plugin for csv files
Plug 'chrisbra/csv.vim'
" A modern Vim and neovim filetype plugin for LaTeX files
" Plug 'lervag/vimtex'
" Start a * or # search from a visual block
Plug 'bronson/vim-visual-star-search'

" Language specific
"" Rust
Plug 'rust-lang/rust.vim'
" Markdown
Plug 'plasticboy/vim-markdown'

" Closes brackets
Plug 'rstacruz/vim-closer'
" Uncover usage problems in your writing
Plug 'reedes/vim-wordy'

" Colorscheme
" find more http://vimcolors.com/
" direct downdown to root dir
" Plug 'joshdick/onedark.vim'
Plug 'drewtempelmeyer/palenight.vim'
Plug 'ulwlu/elly-vscode'
Plug 'patstockwell/vim-monokai-tasty'
" A colorscheme based on the Firefox DevTools
Plug 'kjssad/quantum.vim'
Plug 'srcery-colors/srcery-vim'
Plug 'sainnhe/sonokai'
" like atom dark themes
Plug 'sainnhe/edge'

Plug 'Chiel92/vim-autoformat'
Plug 'preservim/tagbar'

call plug#end()

let g:python3_host_prog="/usr/local/bin/python3"

" Statusline
set laststatus=2
let g:lightline = {}
" let g:lightline.colorscheme = 'onedark'
let g:lightline = { 'colorscheme': 'onedark' }
" 在 Neovim 内启用

" airline
let g:airline#extensions#ale#enabled = 1
let g:airline_theme='onedark'
let g:airline_powerline_fonts = 1
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#formatter = 'default'
" unicode airline symbols
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_left_alt_sep = ''
let g:airline_right_alt_sep = ''
" let g:airline_right_sep = ''
let g:airline_right_sep = '◀'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'
let g:airline_symbols.readonly = ''
let g:airline_statusline_ontop=0

" NerdTree
" 自动打开 NERDTree 在左侧
" autocmd VimEnter * NERDTree
" 过滤所有.pyc文件不显示
let NERDTreeIgnore = ['\.pyc$']  
set wildignore+=*.pyc,*.dex,*.o,*.obj,*.svn,*.swp,*.class,*.hg,*.DS_Store,*.min.*
let NERDChristmasTree = 1
let NERDTreeWinPos = "left"
let NERDTreeHijackNetrw = 1
let NERDTreeChDirMode = 2
let NERDTreeDirArrows = 1
let NERDTreeMinimalUI=1
let NERDTreeShowBookmarks = 0
" 是否显示行号
let g:NERDTreeShowLineNumbers=0
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
let NERDTreeRespectWildIgnore=1
let NERDTreeQuitOnOpen=3
"设定 NERDTree 视窗大小
let g:NERDTreeWinSize=25
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
map <silent> <leader>o :NERDTreeToggle<cr>
map <silent> <leader>f :NERDTreeFind<cr>
" Close vim when nerd tree is the last window
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif


augroup filetypes
    autocmd!
    autocmd FileType vim,tex let b:autoformat_autoindent=0
    autocmd FileType cpp setlocal path+=/usr/include
    autocmd FileType make,go,gitconfig,fstab setlocal noet sts=8 sw=8 ts=8
    autocmd FileType lisp,json,ruby,scheme,clojure setlocal et sts=2 sw=2 ts=8
    autocmd FileType html,css setlocal noet sts=2 sw=2 ts=2
    autocmd FileType python setlocal et sts=4 sw=4 ts=4
    autocmd FileType perl,sh,python,haskell,javascript setlocal tw=79
    autocmd FileType gitcommit setlocal spell

    autocmd FileType tex compiler latexmk
    autocmd FileType perl compiler perl
    autocmd FileType sh compiler shellcheck

    autocmd FileType lisp,clojure,scheme setlocal commentstring=;;%s
    autocmd FileType fstab,crontab,spec setlocal commentstring=#%s

    autocmd BufRead,BufNewFile TODO,DOING,DONE setfiletype outline
    autocmd BufRead,BufNewFile *.asd setfiletype lisp
    " go files seting
    autocmd BufNewFile,BufRead *.go,*.go.tpl setlocal noexpandtab tabstop=2 shiftwidth=2 nolist sts=4
    " Spell check on markdown files
    autocmd BufRead,BufNewFile *.md setlocal spell
    " set filetypes as typescript.tsx
    autocmd BufNewFile,BufRead *.tsx,*.jsx set filetype=typescript.tsx
    " C/C++ flie specific settings
    autocmd BufRead,BufNewFile *.c,*.h,*.cc,*.cpp,*.hpp setlocal ts=4 sw=4 sts=4
    " Redo <https://cr.yp.to/redo.html> <http://news.dieweltistgarnichtso.net/bin/redo-sh.html>
    autocmd BufRead,BufNewFile *.do setlocal filetype=sh
    au BufRead,BufNewFile nginx.conf if &ft == '' | setfiletype nginx | endif
    au BufRead,BufNewFile Dockerfile.dev if &ft == '' | setfiletype Dockerfile | endif
    au BufRead,BufNewFile *.go.tpl set filetype=gotexttmpl
augroup END

" Theme
" FZF and Rg
let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8 } }
let g:fzf_preview_window = 'right:50%'
let $FZF_DEFAULT_OPTS='--reverse --color=bg+:-1'
" let $FZF_DEFAULT_COMMAND = "rg --files --hidden --glob '!.git/**'"
map <leader>f :GFiles<CR>
map <leader>F :Rg<CR>

" Shortcutting split navigation:
nmap <silent> <leader>h :wincmd h<CR>
nmap <silent> <leader>j :wincmd j<CR>
nmap <silent> <leader>k :wincmd k<CR>
nmap <silent> <leader>l :wincmd l<CR>

let g:dashboard_default_executive ='clap'
let g:dashboard_custom_shortcut_icon = {}
let g:dashboard_custom_shortcut_icon['last_session'] = ' '
let g:dashboard_custom_shortcut_icon['last_session'] = ' '
let g:dashboard_custom_shortcut_icon['find_history'] = 'ﭯ '
let g:dashboard_custom_shortcut_icon['find_file'] = ' '
let g:dashboard_custom_shortcut_icon['new_file'] = ' '
let g:dashboard_custom_shortcut_icon['change_colorscheme'] = ' '
let g:dashboard_custom_shortcut_icon['find_word'] = ' '
let g:dashboard_custom_shortcut_icon['book_marks'] = ' '

" https://github.com/glepnir/dashboard-nvim/wiki/Ascii-Header-Text
let g:dashboard_custom_header = [
      \'              ▄▄▄▄▄▄▄▄▄            ',
      \'           ▄█████████████▄          ',
      \'   █████  █████████████████  █████  ',
      \'   ▐████▌ ▀███▄       ▄███▀ ▐████▌  ',
      \'    █████▄  ▀███▄   ▄███▀  ▄█████    ',
      \'    ▐██▀███▄  ▀███▄███▀  ▄███▀██▌    ',
      \'     ███▄▀███▄  ▀███▀  ▄███▀▄███    ',
      \'     ▐█▄▀█▄▀███ ▄ ▀ ▄ ███▀▄█▀▄█▌    ',
      \'      ███▄▀█▄██ ██▄██ ██▄█▀▄███      ',
      \'       ▀███▄▀██ █████ ██▀▄███▀      ',
      \'      █▄ ▀█████ █████ █████▀ ▄█      ',
      \'      ███        ███        ███      ',
      \'      ███▄    ▄█ ███ █▄    ▄███      ',
      \'      █████ ▄███ ███ ███▄ █████      ',
      \'      █████ ████ ███ ████ █████      ',
      \'      █████ ████▄▄▄▄▄████ █████      ',
      \'       ▀███ █████████████ ███▀      ',
      \'         ▀█ ███ ▄▄▄▄▄ ███ █▀        ',
      \'            ▀█▌▐█████▌▐█▀            ',
      \'               ███████              ',
      \ ]

" Keymap
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>
nnoremap <C-f> :TagbarToggle<CR>
