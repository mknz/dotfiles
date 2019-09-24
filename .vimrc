let g:cache_home = empty($XDG_CACHE_HOME) ? expand('$HOME/.cache') : $XDG_CACHE_HOME
let g:config_home = empty($XDG_CONFIG_HOME) ? expand('$HOME/.config') : $XDG_CONFIG_HOME

" vim-plug
call plug#begin('~/.local/share/nvim/plugged')

Plug 'Shougo/denite.nvim'
Plug 'rust-lang/rust.vim'
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'jpalardy/vim-slime'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'moll/vim-bbye'

" Git
Plug  'tpope/vim-fugitive'

" Google search
Plug 'szw/vim-g'

Plug 'jremmen/vim-ripgrep'

call plug#end()

" Use ripgrep in denite
if executable('rg')
  call denite#custom#var('file_rec', 'command',
        \ ['rg', '--files', '--glob', '!.git'])
  call denite#custom#var('grep', 'command', ['rg'])
endif

let g:deoplete#enable_at_startup = 1

" Rust
let g:deoplete#sources#rust#documentation_max_height = 20

" LRS
" Required for operations modifying multiple buffers like rename.
set hidden

let g:LanguageClient_serverCommands = {
    \ 'rust': ['rustup', 'run', 'nightly', 'rls'],
    \ 'javascript': ['javascript-typescript-stdio'],
    \ 'javascript.jsx': ['tcp://127.0.0.1:2089'],
    \ 'python': ['pyls'],
    \ }
let g:LanguageClient_useVirtualText = 0

nnoremap <F5> :call LanguageClient_contextMenu()<CR>
" Or map each action separately
nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>

" ALE disable highlight
highlight clear ALEError
highlight clear ALEWarning

set expandtab
set backspace=2
set wrapscan
set wildmenu
set nolist
set wrap
set showcmd
set backspace=1
set ruler
set showmatch
set showmode
set smartindent
set tabstop=4
set shiftwidth=4
set wildmode=list:longest

" color scheme
syntax enable
set background=dark
colorscheme slate

set hls
nmap <Esc><Esc> :nohlsearch<CR><Esc>

set virtualedit=all
set incsearch

set encoding=utf-8
set fileencoding=utf-8

let g:sql_type_default = 'mysql'

" for jedi-vim
autocmd FileType python setlocal completeopt-=preview

" remove trailing space
autocmd BufWritePre * :%s/\s\+$//e

" to switch indent etc with file type
filetype plugin indent on

" for terminal mode
tnoremap <silent> <ESC> <C-\><C-n>

" no need to save when buffer switch
set hidden

" auto go to current directory
set autochdir

" close buffer without losing split window
nnoremap <C-c> :bp\|bd#<CR>

set whichwrap=h,l
set ignorecase
set smartcase

" Python Runner
autocmd BufNewFile,BufRead *.py nnoremap <C-e> :!python3 %<CR>

" Pylint
autocmd BufNewFile,BufRead *.py nnoremap <C-l> :!pylint %<CR>

" Enable spell check
autocmd BufNewFile,BufRead *.md set spell

" Load .vimrc on save
autocmd BufWritePost ~/.vimrc source %

" UltiSnips
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsListSnippets="<c-t>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
let g:UltiSnipsEditSplit="vertical"
inoremap <c-x><c-k> <c-x><c-k>
let g:ultisnips_python_style="google"

" Allow clipboard copy
set clipboard=unnamed
set clipboard+=unnamedplus

" vim-slime for work with ipython
let g:slime_python_ipython = 1
let g:slime_target = "tmux"
let g:slime_paste_file = tempname()
let g:slime_default_config = {"socket_name": get(split($TMUX, ","), 0), "target_pane": ":.1"}

" Search DuckDuckGo
let g:vim_g_query_url = "https://duckduckgo.com/?q="

" netrw
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_winsize = 20

" vim-bbye
nnoremap <Leader>q :Bdelete<CR>

" less behaviour for view
" https://stackoverflow.com/a/39836959/2192488

" http://vim.wikia.com/wiki/Using_vim_as_a_syntax-highlighting_pager
function! LessBehaviour()
    if (!&modifiable || &ro)
        set nonumber
        set nospell
        set laststatus=0    " Status line
        set cmdheight=1
        set guioptions=aiMr    " No menu bar, nor tool bar
        noremap u <C-u>
        noremap d <C-d>
        noremap q :q<CR>
    endif
endfunction

" https://vi.stackexchange.com/a/9101/3168
augroup ReadOnly
    au!
    au VimEnter * :call LessBehaviour()
augroup END
