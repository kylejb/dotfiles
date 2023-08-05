syntax on

set noerrorbells
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set number
set smartcase
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set incsearch
set ruler
set wildmenu
set wildmode=longest:full,full
set whichwrap+=<,>,h,l,[,]
set nocompatible              " be iMproved, required
set mouse=a
filetype plugin indent on

call plug#begin('~/.vim/plugged')
" Functional stuff
Plug 'tpope/vim-fugitive' "fancy git stuff
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'scrooloose/nerdtree'
Plug 'mhinz/vim-startify'
Plug 'davidhalter/jedi-vim', { 'for': 'python' }
Plug 'hynek/vim-python-pep8-indent', { 'for': 'python' }
Plug 'tell-k/vim-autopep8', { 'for': 'python' }
Plug 'jremmen/vim-ripgrep'
Plug 'hashivim/vim-terraform'
Plug 'airblade/vim-gitgutter'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Aesthetics
Plug 'morhetz/gruvbox' " gruvbox
Plug 'vim-airline/vim-airline' " airline
call plug#end()
let g:airline_theme='gruvbox'
set background=dark
colorscheme gruvbox
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
set termguicolors

""""""""""""""
" HOTKEYS
""""""""""""""
:map // :BLines<CR>
:map cc :Commands<CR>

let mapleader = "\<Space>"
" files
nmap <silent>f :Files<CR>
nmap <leader>t :tabnew<CR>
"nmap <leader>x :terminal<CR>
" Explorer
nmap <leader>e :call ToggleNERDTree()<CR>
" split
noremap <leader>s :vsp<CR>
nnoremap <leader><Right> <C-W><C-L>
nnoremap <leader><Left> <C-W><C-H>
nnoremap <leader><Up> <C-W><C-K>
nnoremap <leader><Down> <C-W><C-J>
nnoremap <leader>ac <nop>

"makme leader number switch to corresponding tab
noremap <leader>1 1gt
noremap <leader>2 2gt
noremap <leader>3 3gt
noremap <leader>4 4gt
noremap <leader>5 5gt
noremap <leader>6 6gt
noremap <leader>7 7gt
noremap <leader>8 8gt
noremap <leader>9 9gt
noremap <leader>0 :tablast<cr>

command! WQ wq
command! Wq wq
command! W w
command! Q q
command! QA qa
command! Qa qa


" make python do its thing
autocmd FileType python setlocal omnifunc=jedi#completions

set wildignore+=*.pyc,*.o,*.obj,*.svn,*.swp,*.class,*.hg,*.DS_Store,*.min.*,*.terraform*
let NERDTreeRespectWildIgnore=1

function! ToggleNERDTree()
  NERDTreeToggle
  silent NERDTreeMirror
endfunction

" terraform stuff
let g:terraform_align=1
let g:terraform_fmt_on_save=1


" Read ~/.NERDTreeBookmarks file and takes its second column
function! s:nerdtreeBookmarks()
    let bookmarks = systemlist("cut -d' ' -f 2- ~/.NERDTreeBookmarks")
    let bookmarks = bookmarks[0:-2] " Slices an empty last line
    return map(bookmarks, "{'line': v:val, 'path': v:val}")
endfunction

let g:startify_custom_header =[]
let g:startify_lists = [
        \ { 'type': function('s:nerdtreeBookmarks'), 'header': ['   NERDTree Bookmarks']},
        \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] }
        \]
function! s:gitModified()
    let files = systemlist('git ls-files -m 2>/dev/null')
    return map(files, "{'line': v:val, 'path': v:val}")
endfunction

" same as above, but show untracked files, honouring .gitignore
function! s:gitUntracked()
    let files = systemlist('git ls-files -o --exclude-standard 2>/dev/null')
    return map(files, "{'line': v:val, 'path': v:val}")
endfunction

"autocmd vimenter * if !argc() | NERDTree | endif
"nnoremap = :call nerdtree#invokeKeyMap("o")<CR>
"let NERDTreeQuitOnOpen=0
let NERDTreeShowHidden=1
autocmd StdinReadPre * let s:std_in=1
"autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTreeToggle | endif
"exec "nnoremap <silent> <buffer> ". g:NERDTreeMapOpenInTab ." :call <SID>openInNewTab(0)<cr>:NERDTree<cr>"
autocmd BufWinEnter * NERDTreeMirror
autocmd VimEnter *
            \   if !argc()
            \ |   Startify
            \ |   NERDTreeToggle
            \ |   wincmd w
            \ | endif
