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
" Expand all tabs to spaces
set expandtab
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
colorscheme elflord

" spelling
highlight clear SpellBad
highlight SpellBad cterm=underline

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
augroup cpp
	autocmd!
	" Set compiler.
	autocmd Filetype cpp set makeprg=g++
	" Execute result.
	autocmd Filetype cpp nnoremap <buffer> <space>r :cd %:p:h<cr>:!clear;./a.out<cr>
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
	autocmd Filetype ruby set ts=2 sts=2 sw =2
	autocmd Filetype yaml set ts=2 sts=2 sw =2
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
	au Filetype tex inoremap <buffer> ;lc \begin{compactitem}<cr>\end{compactitem}<ESC>ko\item<space>
	au Filetype tex inoremap <buffer> ;le \begin{enumerate}<cr>\end{enumerate}<ESC>ko\item<space>
	au Filetype tex inoremap <buffer> ;ld \begin{description}<cr>\end{description}<ESC>ko\item[]\hfill<cr><tab><++><ESC>k0f[a
	au Filetype tex inoremap <buffer> ;ca \begin{cases}<cr>\end{cases}<ESC>ko
	au Filetype tex inoremap <buffer> ;tb \begin{tabular}{llllllllll}<cr>\end{tabular}<ESC>ko\toprule<cr>\midrule<cr>\bottomrule<ESC>kko
	au Filetype tex inoremap <buffer> ;ll \begin{lstlisting}<cr>\end{lstlisting}<ESC>ko
	au Filetype tex inoremap <buffer> ;df \begin{definition}[]<cr>\end{definition}<ESC>ko<++><esc>k0f[a
	au Filetype tex inoremap <buffer> ;xp \begin{example}[]<cr>\end{example}<ESC>ko<++><esc>k0f[a
	"au Filetype tex inoremap <buffer> ;sl \begin{solution}<cr>\end{solution}<ESC>ko<++><esc>k0f[a
	au Filetype tex inoremap <buffer> ;sl \begin{slide}<cr>\end{slide}<ESC>ko
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



