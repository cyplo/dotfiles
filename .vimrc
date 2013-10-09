" Shortcut to rapidly toggle `set list`
nmap <leader>l :set list!<CR>
" Use the same symbols as TextMate for tabstops and EOLs
set listchars=tab:▸\ ,eol:¬

"Invisible character colors
highlight NonText guifg=#4a4a59
highlight SpecialKey guifg=#4a4a59

set t_Co=256
syntax on

set background=dark
color solarized 
colorscheme solarized 

set noswapfile

execute pathogen#infect()
filetype plugin indent on
