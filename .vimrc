let g:cache_home = empty($XDG_CACHE_HOME) ? expand('$HOME/.cache') : $XDG_CACHE_HOME
let g:config_home = empty($XDG_CONFIG_HOME) ? expand('$HOME/.config') : $XDG_CONFIG_HOME

" vim-plug
call plug#begin('~/.local/share/nvim/plugged')

Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
Plug 'dense-analysis/ale'
Plug 'jpalardy/vim-slime'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'moll/vim-bbye'

" Git
Plug  'tpope/vim-fugitive'

" Google search
Plug 'szw/vim-g'

Plug 'jremmen/vim-ripgrep'

" You need to manually finish the installation
" export PYTHON_CONFIGURE_OPTS="--enable-shared"
" pyenv install <VERSION>
" cd ~/.local/share/nvim/plugged/YouCompleteMe ; python3 install.py --all
Plug 'Valloric/YouCompleteMe'
Plug 'morhetz/gruvbox'
call plug#end()

" ALE
let g:ale_linters = {
\   'python': ['pylint', 'mypy', 'pyright', 'flake8', 'pydocstyle'],
\}
let g:ale_rust_rls_config = {'rust': {'clippy_preference': 'on'}}
nnoremap <silent> D :ALEDetail<CR>

" LanguageClient
let g:LanguageClient_autoStart = 1
let g:LanguageClient_serverCommands = {
    \ 'python': ['pyls'],
    \ 'rust': ['$HOME/.local/share/nvim/plugged/YouCompleteMe/third_party/ycmd/third_party/rust-analyzer/bin/rust-analyzer'],
    \ 'vim': ['vim-language-server', '--stdio'],
    \ 'javascript': ['javascript-typescript-stdio'],
    \ 'javascript.jsx': ['tcp://127.0.0.1:2089'],
    \ }
let g:LanguageClient_useVirtualText = 'No'

nnoremap <F5> :call LanguageClient_contextMenu()<CR>
nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>

set expandtab
set showmatch
set smartindent
set tabstop=4
set shiftwidth=4
set wildmode=list:longest

" color scheme
colorscheme gruvbox

nmap <Esc><Esc> :nohlsearch<CR><Esc>

set virtualedit=all

set encoding=utf-8
set fileencoding=utf-8

let g:sql_type_default = 'mysql'

autocmd FileType python setlocal completeopt-=preview

" remove trailing space
autocmd BufWritePre * :%s/\s\+$//e

" to switch indent etc with file type
filetype plugin indent on

" for terminal mode
tnoremap <silent> <ESC> <C-\><C-n>

" no need to save when buffer switch
set hidden

" Always set current directory
set autochdir

" close buffer without losing split window
nnoremap <C-c> :bp\|bd#<CR>

set whichwrap=h,l
set ignorecase
set smartcase

" Pylint
autocmd BufNewFile,BufRead *.py nnoremap <C-l> :!pylint %<CR>

" Enable spell check
autocmd BufNewFile,BufRead *.md set spell

" Allow clipboard copy
set clipboard=unnamed
set clipboard+=unnamedplus

" vim-slime with ipython
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

" less-like behavior in read-only mode
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

command! Gb Gblame

" Filetypes
autocmd FileType html setlocal shiftwidth=2 tabstop=2
autocmd FileType sql setlocal shiftwidth=2 tabstop=2

" Omni completion by Ctrl-N
inoremap <C-N> <C-X><C-O>
