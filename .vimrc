"=============================================================
"== notori0us .vimrc					    ==
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
" Use visual bell instead of beeping when doing something wrong
set visualbell
" Enable filetype-specific plugins
filetype plugin on
" Use filetype-specific automatic indentation
filetype indent on

" Mappings
"-------------------------------------------------------------
" Disable <f1>'s default help functionality.
nnoremap <f1> <esc>
inoremap <f1> <esc>

"---Mappings for tex
"-------------------------------------------------------------
" Various LaTeX mappings to save keystrokes in common situations
au Filetype tex inoremap <buffer> ;; <ESC>o\item<space>
au Filetype tex inoremap <buffer> ;' <ESC>o\item[]\hfill<cr><TAB><++><ESC>k0f[a
au Filetype tex inoremap <buffer> (( \left(\right)<++><ESC>10hi
au Filetype tex inoremap <buffer> [[ \left[\right]<++><ESC>10hi
au Filetype tex inoremap <buffer> {{ \left\{\right\}<++><ESC>10hi
au Filetype tex inoremap <buffer> __ _{}<++><ESC>4hi
au Filetype tex inoremap <buffer> ^^ ^{}<++><ESC>4hi
au Filetype tex inoremap <buffer> == &=<space>
au Filetype tex inoremap <buffer> ;new \documentclass{}<cr>\begin{document}<cr><++><cr>\end{document}<ESC>3kf{a
au Filetype tex inoremap <buffer> ;use \usepackage{}<ESC>i
au Filetype tex inoremap <buffer> ;f \frac{}{<++>}<++><ESC>10hi
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
au Filetype tex inoremap <buffer> ;sl \begin{solution}<cr>\end{solution}<ESC>ko<++><esc>k0f[a
" Tabularize mappingts for common TeX alignment situations
"au Filetype tex vnoremap <buffer> <space>& :Tab /&<cr>
"au Filetype tex vnoremap <buffer> <space>\ :Tab /\\\\<cr>
"au Filetype tex vnoremap <buffer> <space>tl :Tab /&<cr>gv:Tab /\\\\<cr>
"au Filetype tex nnoremap <buffer> <space>& :Tab /&<cr>
"au Filetype tex nnoremap <buffer> <space>\ :Tab /\\\\<cr>
"au Filetype tex nnoremap <buffer> <space>tl :Tab /&<cr>gv:Tab /\\\\<cr>

" ETC
"-------------------------------------------------------------
" Quickly time out on keycodes, but never time out on mappings
set notimeout ttimeout ttimeoutlen=200



