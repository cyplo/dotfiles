" global settings
set nocompatible
set noswapfile
set undofile
set undodir=$HOME/.vim/undo

" buffers can be switched despite having changes
set hidden

" file settings
set encoding=utf-8

" key mappings
let mapleader = ","
nmap <leader>p :set paste!<CR>
nmap <leader>h :set hlsearch!<CR>

" navigate buffers by ctrl-b
nmap <C-b> :bprevious<CR>

nnoremap ; :

" no cheating !
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>

" for damaged keyboards
map <F1> <Esc>
imap <F1> <Esc>

" special chars
nmap <leader>l :set list!<CR>
set listchars=tab:▸\ ,eol:¬
highlight NonText guifg=#4a4a59
highlight SpecialKey guifg=#4a4a59

" tabs and spaces
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

" plugins
execute pathogen#infect()
filetype plugin indent on

" colours [need pathogen]
set t_Co=256
syntax enable
set background=dark
highlight clear SignColumn
colorscheme solarized

" plugins: airline
let g:bufferline_echo = 0
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1


" appearance
set number
set relativenumber
set laststatus=2
set noshowmode
set showtabline=1 "only show tabline when more than 1 tab

" vimdiff
set diffopt+=iwhite
set diffexpr=""
