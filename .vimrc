" Shortcut to rapidly toggle `set list`
nmap <leader>l :set list!<CR>
" Use the same symbols as TextMate for tabstops and EOLs
set listchars=tab:▸\ ,eol:¬

set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

"Invisible character colors
highlight NonText guifg=#4a4a59
highlight SpecialKey guifg=#4a4a59

set t_Co=256
syntax on

set background=dark
color solarized 
colorscheme solarized 

set noswapfile
set encoding=utf-8

execute pathogen#infect()
filetype plugin indent on

"always show statusline
set laststatus=2
"don't show default mode indicators
set noshowmode
"airline
let g:bufferline_echo = 0
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

" clear sign column, for git gutter etc
highlight clear SignColumn

