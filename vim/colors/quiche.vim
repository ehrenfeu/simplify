" Vim color file
" Maintainer:	Niko Ehrenfeuchter
" Last Change:	2015 June 07
" based on colorscheme "torte" by Thorsten Maerz <info@netztorte.de>
" grey on transparent bg, optimized for TFT panels

set background=dark
highlight clear
if exists("syntax_on")
  syntax reset
endif
"colorscheme default
let g:colors_name = "quiche"

" hardcoded colors :
" GUI Comment : #80a0ff = Light blue

" Console
highlight Normal     ctermfg=LightGrey
highlight Search     ctermfg=Black	ctermbg=Red	cterm=NONE
highlight Visual					cterm=reverse
highlight Cursor     ctermfg=Black	ctermbg=Green	cterm=bold
highlight Special    ctermfg=Brown
highlight Comment    ctermfg=Blue
highlight StatusLine ctermfg=blue	ctermbg=white
highlight Statement  ctermfg=Yellow			cterm=NONE
highlight Type						cterm=NONE
"highlight Folded     ctermbg=black   ctermfg=lightblue
"highlight Folded     ctermbg=104E8B   ctermfg=lightblue
highlight Folded     ctermbg=104E8B   ctermfg=darkgrey
highlight Typedef    ctermfg=Red
