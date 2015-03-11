" fix vim compatability
set nocompatible
filetype off

" Vundle magic
"
" Installation:
" 	open vim
" 	run :BundleInstall
"
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin('~/.vim/vundle')
"call vundle#rc()

" Let Vundle manage Vundle
Plugin 'gmarik/Vundle.vim'

" fancy status bar
Plugin 'Lokaltog/vim-powerline.git'
set laststatus=2 " set this to 2 to bring it back

" fuzy search
Plugin 'kien/ctrlp.vim.git'
"" let g:ctrlp_custom_ignore= "(jar|class|swp|swo|log|so|o|pyc|jpe?g|png|gif|mo|po)$"
let g:ctrlp_regexp = 1      " default=0
let g:ctrlp_max_files = 0   " default=10000
let ctrlp_filter_greps = "".
    \ "egrep -iv '\\.(" .
    \ "jar|class|swp|swo|log|so|o|pyc|jpe?g|png|gif|mo|po" .
    \ ")$' | " .
    \ "egrep -v '^(\\./)?(" .
    \ "vendor/|lib/|classes/|libs/|deploy/|.git/|.hg/|.svn/|.*migrations/" .
    \ ")'"
let my_ctrlp_git_command = "" .
    \ "cd %s && git ls-files | " .
    \ ctrlp_filter_greps
if has("unix")
    let my_ctrlp_user_command = "" .
    \ "find %s '(' -type f -or -type l ')' -maxdepth 15 -not -path '*/\\.*/*' | " .
    \ ctrlp_filter_greps
endif
let g:ctrlp_user_command = ['.git/', my_ctrlp_git_command, my_ctrlp_user_command]

" needed for legacy
Plugin 'tpope/vim-pathogen.git'

" Git
Plugin 'tpope/vim-fugitive.git'
Plugin 'airblade/vim-gitgutter.git'

if v:version > 703 || (v:version == 703 && has('patch584'))
	" autocomplete
	Plugin 'Valloric/YouCompleteMe.git'
endif

" syntax
Plugin 'kchmck/vim-coffee-script.git'
Plugin 'rodjek/vim-puppet.git'
Plugin 'vim-scripts/python.vim.git'
syntax on

" checking syntax errors
Plugin 'scrooloose/syntastic.git'

" nice python indenting
Plugin 'hynek/vim-python-pep8-indent.git'
 
" Rainbow parenthesis - https://github.com/kien/rainbow_parentheses.vim
Plugin 'kien/rainbow_parentheses.vim'

" Clojure Stuff
Plugin 'guns/vim-clojure-static'
" Editing stuff for S-expressions (forms, elements...). Alternative to paredit.vim. - https://github.com/guns/vim-sexp
Plugin 'guns/vim-sexp'
Plugin 'tpope/vim-sexp-mappings-for-regular-people'
" REPL Help for fireplace
Plugin 'clojure-emacs/cider-nrepl'
" REPL - https://github.com/tpope/vim-fireplace
Plugin 'tpope/vim-fireplace'
Plugin 'tpope/vim-leiningen'

call vundle#end()
filetype plugin indent on

" map jj to normal mode
imap jj <Esc>

" map f2 to toggle past mode
set pastetoggle=<F2>

" super fast up and down movement
nnoremap <c-j> 5<c-e>
nnoremap <c-k> 5<c-y>

" set 256 colors
set t_Co=256

" colors
"colorscheme jellybeans
colorscheme murphy

" set guifont=Menlo\ Regular:h14
set encoding=utf-8
set antialias
set guifont=Source\ Code\ Pro\ Light:h18

" clean up gitgutter
highlight clear SignColumn

" turn on search highlighting
set hlsearch

" show line numbers
set number

" allow switching out of modified buffers
set hidden

" mark the 81st column
set colorcolumn=81
hi ColorColumn ctermbg=lightyellow guibg=lightyellow 

" highlight current line
"set cursorline cursorcolumn

" Unset undesirable rules
set nocindent
set nosmartindent

" Normal indentation rules
set tabstop=4
set shiftwidth=4
set autoindent

au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces
" au Syntax * RainbowParenthesesLoadChevrons

" kill trailing whitespace function
fun! KillTrailingWhitespace()
	autocmd BufWritePre <buffer> :%s/\s\+$//e
endfun

set expandtab

" set C preferences (chartbeat does spaces?)
autocmd FileType c
			\ set expandtab |
			\ set softtabstop=4 |
			\ call KillTrailingWhitespace()

" set C++ preferences (chartbeat does spaces?)
autocmd FileType cpp
			\ set expandtab |
			\ set softtabstop=4 |
			\ call KillTrailingWhitespace()

" set ruby preferences
autocmd FileType ruby
			\ set expandtab |
			\ set shiftwidth=2 |
			\ set softtabstop=2 |
			\ call KillTrailingWhitespace()

" set eruby preferences
autocmd FileType eruby
			\ set expandtab |
			\ set shiftwidth=4 |
			\ set softtabstop=4 |
			\ call KillTrailingWhitespace()

" set html preferences
autocmd FileType html 
			\ set shiftwidth=2 |
			\ set tabstop=2 |
			\ call KillTrailingWhitespace()

" set html preferences
autocmd FileType jade
			\ set expandtab |
			\ set shiftwidth=2 |
			\ set softtabstop=2 |
			\ call KillTrailingWhitespace() 

" set coffee preferences
autocmd FileType coffee
			\ set expandtab |
			\ set shiftwidth=2 |
			\ set softtabstop=2 |
			\ call KillTrailingWhitespace() |
			\ hi link coffeeSpaceError NONE

" set javascript preferences
autocmd FileType javascript
			\ set expandtab |
			\ set shiftwidth=2 |
			\ set softtabstop=2 |
			\ call KillTrailingWhitespace()

" set python preferences
autocmd FileType python
			\ set shiftwidth=4 |
			\ set softtabstop=4 |
			\ set smarttab |
			\ set expandtab |
			\ set colorcolumn=120 |
			\ call KillTrailingWhitespace() |
			\ let g:syntastic_python_checkers = ['flake8']

" set puppet preferences
autocmd FileType puppet
			\ set expandtab |
			\ set shiftwidth=2 |
			\ set softtabstop=2 |
			\ call KillTrailingWhitespace()

" set yaml preferences
autocmd FileType yaml
			\ set expandtab |
			\ set shiftwidth=2 |
			\ set softtabstop=2 |
			\ call KillTrailingWhitespace()

autocmd FileType clojure 
            \ setlocal lispwords+=describe,it,testing,facts,fact,provided |
			\ call KillTrailingWhitespace() 

 
" This should enable Emacs like indentation
" Emacs-like indenting for closure
let g:clojure_fuzzy_indent=1
let g:clojure_align_multiline_strings = 1

" Add some words which should be indented like defn etc: Compojure/compojure-api, midje and schema stuff mostly.
let g:clojure_fuzzy_indent_patterns=['^GET', '^POST', '^PUT', '^DELETE', '^ANY', '^HEAD', '^PATCH', '^OPTIONS', '^def']
 
" Disable some irritating mappings
let g:sexp_enable_insert_mode_mappings = 0
