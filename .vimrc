"=============================================================
"== notori0us .vimrc                                        ==
"=============================================================
" General Settings
"-------------------------------------------------------------
" Disable compatability
set nocompatible
" Use Autoindenting
set autoindent
" Enable syntax highlighting
syntax on
" Set normal backspace
set backspace=2
" Allow unsaved buffers in background
set hidden
" Show partial commands in the last line of the screen
set showcmd
" Highlight searches
set hlsearch
" Disable modeline- security
set nomodeline
" Use case insensitive search
set ignorecase
" Except when using capital letters
set smartcase
" Always display the status line, even if only one window is displayed
set laststatus=2
" Set the command window height to 2 lines
set cmdheight=2
" Make tabs 4 characters wide
set tabstop=4
" Autoindents are 4 characters wide
set shiftwidth=4
" Show position is statusline
set ruler
" Set terminal title
set title
" Disable capitalization check in spellcheck
set spellcapcheck=""
" Do not show introduction message when starting vim
set shortmess=I
" Enable filetype-specific plugins
filetype plugin on
" Use filetype-specific automatic indentation
filetype indent on
" line numbers
set number

" pathogen
"-------------------------------------------------------------
call pathogen#infect() 

" skybison
"-------------------------------------------------------------
nnoremap : :<c-u>call SkyBison("")<cr>

" Awesome indents
"-------------------------------------------------------------
set list
set listchars=tab:>·,trail:·,extends:…,precedes:…,nbsp:&

" Mappings
"-------------------------------------------------------------
" Disable <f1>'s default help functionality.
nnoremap <f1> <esc>
inoremap <f1> <esc>

command! SyntaxGroup echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')

" easy make command
nnoremap <space>m :w<cr>:!clear<cr>:silent make %<cr>:cc<cr>
" easy write command
nnoremap <space>w :w<cr>

"if &t_Co == 256

" Theming
"-------------------------------------------------------------
" Grayscale:
let nfg = 231 " white
let nbg = 0 " black
let hfg = 0 " black
let hbg = 231 " white
let ifg = 240 " about 30% white
let ibg = 0 " black
let efg = 196 " red
let ebg = 0 " black
let m1fg = 250 " gray 74
let m1bg = 0 " black
let m2fg = 248 " gray 66
let m2bg = 0 " black
let m3fg = 244 " gray 50
let m3bg = 0 " black
let m4fg = 257 " gray 82
let m4bg = 0 " black

" ------------------------------------------------------------------------------
"- general syntax (theme) -
"  ------------------------------------------------------------------------------
execute "highlight Comment cterm = NONE"
execute "highlight Comment ctermfg = " . ifg
execute "highlight Comment ctermbg = " . ibg
execute "highlight Constant cterm = NONE"
execute "highlight Constant ctermfg = " . m3fg
execute "highlight Constant ctermbg = " . m3bg
execute "highlight Error cterm = NONE"
execute "highlight Error ctermfg = " . m2fg
execute "highlight Error ctermbg = " . m2bg
execute "highlight Identifier cterm = NONE"
execute "highlight Identifier ctermfg = " . m3fg
execute "highlight Identifier ctermbg = " . m3bg
execute "highlight PreProc cterm = NONE"
execute "highlight PreProc ctermfg = " . m2fg
execute "highlight PreProc ctermbg = " . m2bg
execute "highlight Special cterm = NONE"
execute "highlight Special ctermfg = " . m1fg
execute "highlight Special ctermbg = " . m1bg
execute "highlight Statement cterm = NONE"
execute "highlight Statement ctermfg = " . m1fg
execute "highlight Statement ctermbg = " . m1bg
execute "highlight Type cterm = NONE"
execute "highlight Type ctermfg = " . m4fg
execute "highlight Type ctermbg = " . m4bg
" spelling
highlight clear SpellBad
highlight SpellBad cterm=underline

" ------------------------------------------------------------------------------
"  " - vim chrome (theme) -
"  ------------------------------------------------------------------------------


execute "highlight LineNr cterm = None"
execute "highlight LineNr ctermfg = " . ifg
execute "highlight LineNr ctermbg = " . ibg
execute "highlight SpecialKey cterm = NONE"
execute "highlight SpecialKey ctermfg = " . ifg
execute "highlight SpecialKey ctermbg = " . ibg
execute "highlight Folded cterm = NONE"
execute "highlight Folded ctermfg = " . ifg
execute "highlight Folded ctermbg = " . ibg
execute "highlight MatchParen cterm = NONE"
execute "highlight MatchParen ctermfg = " . hfg
execute "highlight MatchParen ctermbg = " . hbg
execute "highlight NonText cterm = NONE"
execute "highlight NonText ctermfg = " . ifg
execute "highlight NonText ctermbg = " . ibg
execute "highlight Search cterm = NONE"
execute "highlight Search ctermfg = " . hfg
execute "highlight Search ctermbg = " . hbg
execute "highlight ModeMsg cterm = NONE"
execute "highlight ModeMsg ctermfg = " . ifg
execute "highlight ModeMsg ctermbg = " . ibg
execute "highlight MoreMsg cterm = NONE"
execute "highlight MoreMsg ctermfg = " . ifg
execute "highlight MoreMsg ctermbg = " . ibg
execute "highlight Pmenu cterm = NONE"
execute "highlight Pmenu ctermfg = " . nfg
execute "highlight Pmenu ctermbg = " . nbg
execute "highlight PmenuSel cterm = NONE"
execute "highlight PmenuSel ctermfg = " . hfg
execute "highlight PmenuSel ctermbg = " . hbg
execute "highlight PmenuSbar cterm = NONE"
execute "highlight PmenuSbar ctermfg = " . efg
execute "highlight PmenuSbar ctermbg = " . ebg
execute "highlight StatusLine cterm = NONE"
execute "highlight StatusLine ctermfg = " . ifg
execute "highlight StatusLine ctermbg = " . ibg
execute "highlight StatusLineNC cterm = NONE"
execute "highlight StatusLineNC ctermfg = " . ifg
execute "highlight StatusLineNC ctermbg = " . ibg
execute "highlight TabLine cterm = NONE"
execute "highlight TabLine ctermfg = " . ifg
execute "highlight TabLine ctermbg = " . ibg
execute "highlight TabLineFill cterm = NONE"
execute "highlight TabLineFill ctermbg = " . nfg
execute "highlight TabLineSel cterm = NONE"
execute "highlight TabLineSel ctermfg = " . hfg
execute "highlight TabLineSel ctermbg = " . hbg
execute "highlight Title cterm = NONE"
execute "highlight Title ctermfg = " . ifg
execute "highlight Title ctermbg = " . ibg
execute "highlight VertSplit cterm = NONE"
execute "highlight VertSplit ctermfg = " . ifg
execute "highlight VertSplit ctermbg = " . ibg
execute "highlight Visual cterm = NONE"
execute "highlight Visual ctermfg = " . nbg
execute "highlight Visual ctermbg = " . nfg

"endif

"---Python Mappings
"-------------------------------------------------------------
" Convert indentation from spaces to tabs when opening a file.
au Filetype python retab!
" Convert indentation from tabs to spaces when wring a file to disk, then
" immediately back when saving is done.
au Filetype python au BufWritePre * :set expandtab
au Filetype python au BufWritePre * :retab!
au Filetype python au BufWritePost * :set noexpandtab!
au Filetype python au BufWritePost * :retab!

augroup python
	autocmd Filetype python nnoremap <buffer> <space>r :cd %:p:h<cr>:!clear;perl %<cr>
augroup END

"---C Mappings
"-------------------------------------------------------------
augroup c
	autocmd!
	" Set compiler.
	autocmd Filetype c set makeprg=gcc
	" Execute result.
	autocmd Filetype c nnoremap <buffer> <space>r :cd %:p:h<cr>:!clear;./a.out<cr>
augroup END

"---C++ Mappings
"-------------------------------------------------------------
augroup c++
	autocmd!
	" Set compiler.
	autocmd Filetype c++ set makeprg=g++
	" Execute result.
	autocmd Filetype c++ nnoremap <buffer> <space>r :cd %:p:h<cr>:!clear;./a.out<cr>
augroup END


"---Perl Mappings
"-------------------------------------------------------------
augroup perl
	autocmd Filetype perl nnoremap <buffer> <space>r :cd %:p:h<cr>:!clear;perl %<cr>
augroup END

"---Ruby Mappings
"-------------------------------------------------------------
augroup ruby
	autocmd Filetype ruby nnoremap <buffer> <space>r :cd %:p:h<cr>:!clear;ruby %<cr>
augroup END

"---TeX Mappings
"-------------------------------------------------------------
"let g:tex_flavor='latex'
augroup latex
	" compile command
	autocmd Filetype tex setlocal makeprg=lualatex\ \-file\-line\-error\ \-interaction=nonstopmode\ $*\\\|\ awk\ '/^\\(.*.tex$/{sub(/^./,\"\",$0);X=$0}\ /^!/{sub(/^./,\"\",$0);print\ X\":1:\"$0}\ /tex:[0-9]+:\ /{A=$0;MORE=2}\ (MORE==2\ &&\ /^l.[0-9]/){sub(/^l.[0-9]+[\ \\t]+/,\"\",$0);B=$0;MORE=1}\ (MORE==1\ &&\ /^[\ ]+/){sub(/^[\ \\t]+/,\"\",$0);print\ A\":\ \"B\"·\"$0;MORE=0}'

	" Various LaTeX mappings to save keystrokes in common situations
	au Filetype tex inoremap <buffer> ;; <ESC>o\item<space>
	"au Filetype tex inoremap <buffer> ;' <ESC>o\item[]\hfill<cr><TAB><++><ESC>k0f[a
	"au Filetype tex inoremap <buffer> (( \left(\right)<++><ESC>10hi
	"au Filetype tex inoremap <buffer> [[ \left[\right]<++><ESC>10hi
	"au Filetype tex inoremap <buffer> {{ \left\{\right\}<++><ESC>10hi
	au Filetype tex inoremap <buffer> __ _{}<ESC>i
	au Filetype tex inoremap <buffer> ^^ ^{}<ESC>i
	"au Filetype tex inoremap <buffer> == &=<space>
	au Filetype tex inoremap <buffer> ;new \documentclass{}<cr>\begin{document}<cr><++><cr>\end{document}<ESC>3kf{a
	au Filetype tex inoremap <buffer> ;use \usepackage{}<ESC>i
	au Filetype tex inoremap <buffer> ;f \frac{}{}<ESC>2hi
	au Filetype tex inoremap <buffer> ;td \todo[]{}<esc>i
	au Filetype tex inoremap <buffer> ;sk \sketch[]{}<esc>i
	au Filetype tex inoremap <buffer> ;mi \begin{minipage}{.9\columnwidth}<cr>\end{minipage}<ESC>ko
	au Filetype tex inoremap <buffer> ;al \begin{align*}<cr>\end{align*}<ESC>ko
	au Filetype tex inoremap <buffer> ;mb \begin{bmatrix}<cr>\end{bmatrix}<ESC>ko
	au Filetype tex inoremap <buffer> ;mp \begin{pmatrix}<cr>\end{pmatrix}<ESC>ko
	au Filetype tex inoremap <buffer> ;li \begin{itemize}<cr>\end{itemize}<ESC>ko\item<space>
	au Filetype tex inoremap <buffer> ;le \begin{enumerate}<cr>\end{enumerate}<ESC>ko\item<space>
	au Filetype tex inoremap <buffer> ;ld \begin{description}<cr>\end{description}<ESC>ko\item[]\hfill<cr><tab><++><ESC>k0f[a
	au Filetype tex inoremap <buffer> ;ca \begin{cases}<cr>\end{cases}<ESC>ko
	au Filetype tex inoremap <buffer> ;tb \begin{tabular}{llllllllll}<cr>\end{tabular}<ESC>ko\toprule<cr>\midrule<cr>\bottomrule<ESC>kko
	au Filetype tex inoremap <buffer> ;ll \begin{lstlisting}<cr>\end{lstlisting}<ESC>ko
	au Filetype tex inoremap <buffer> ;df \begin{definition}[]<cr>\end{definition}<ESC>ko<++><esc>k0f[a
	au Filetype tex inoremap <buffer> ;xp \begin{example}[]<cr>\end{example}<ESC>ko<++><esc>k0f[a
	"au Filetype tex inoremap <buffer> ;sl \begin{solution}<cr>\end{solution}<ESC>ko<++><esc>k0f[a
	au Filetype tex inoremap <buffer> ;sl \begin{slide}<cr>\end{slide}<ESC>ko<space>
	au Filetype tex inoremap <buffer> ;b \textbf{}<ESC>i
	au Filetype tex inoremap <buffer> ;i \textit{}<ESC>i
	" Tabularize mappingts for common TeX alignment situations
	"au Filetype tex vnoremap <buffer> <space>& :Tab /&<cr>
	"au Filetype tex vnoremap <buffer> <space>\ :Tab /\\\\<cr>
	"au Filetype tex vnoremap <buffer> <space>tl :Tab /&<cr>gv:Tab /\\\\<cr>
	"au Filetype tex nnoremap <buffer> <space>& :Tab /&<cr>
	"au Filetype tex nnoremap <buffer> <space>\ :Tab /\\\\<cr>
	"au Filetype tex nnoremap <buffer> <space>tl :Tab /&<cr>gv:Tab /\\\\<cr>


	autocmd Filetype tex nnoremap <buffer> <space>r :cd %:p:h<cr>:!clear;evince %<.pdf > /dev/null 2>&1 &<cr>
augroup END

" ETC
"-------------------------------------------------------------
" Quickly time out on keycodes, but never time out on mappings
set notimeout ttimeout ttimeoutlen=200



