# With great thanks and credit to Paradigm and his wonderfully crafted .zshrc
# https://github.com/paradigm/dotfiles/blob/master/.zshrc

# Lines configured by zsh-newuser-install, minus those also set by Paradigm
HISTFILE=~/.history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
#zstyle :compinstall filename '/home/embo/.zshrc'

# autocompletion?
autoload -Uz compinit
compinit
# End of lines added by compinstall

# ==============================================================================
# = auto startx
# ==============================================================================

[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx

# ==============================================================================
# = general settings =
# ==============================================================================

# cd into directory just by directory name
setopt autocd

# prompt to correct typos
setopt correct

# don't propose _shellfunctions when correcting
CORRECT_IGNORE='_*'

# additional glob options
setopt extendedglob

# shut up
setopt nobeep

# don't change nice for bg tasks
setopt nobgnice

# Disable flow control. Specifically, ensure that ctrl-s does not stop
# terminal flow so that it can be used in other programs (such as Vim).
setopt noflowcontrol
stty -ixon

# Do not kill background processes when closing the shell. 
setopt nohup

# Do not warn about closing the shell with background jobs running.
setopt nocheckjobs

# don't record repeated things in history
setopt histignoredups

# allows comments in commands
setopt interactivecomments

# consider / a word break, for ctrl-w
WORDCHARS=${WORDCHARS//\/}

# vi mode
bindkey -v

# ==============================================================================
# = completion =
# ==============================================================================

# $fpath defines where Zsh searches for completion functions. Include one in
# the $HOME directory for non-root-user-made completion functions.

#fpath=(~/.zsh/completion $fpath)

# Zsh's completion can benefit from caching. Set the directory in which to
# load/store the caches.
CACHEDIR="$HOME/.zsh/$(uname -n)"

# Use completion functionality.
autoload -U compinit
compinit -d $CACHEDIR/zcompdump 2>/dev/null

# cache, speed things up
zstyle ':completion:*' use-cache on

# Set the cache location.
zstyle ':completion:*' cache-path $CACHEDIR/cache

# If the <tab> key is pressed with multiple possible options, print the
# options. If the options are printed, begin cycling through them.
zstyle ':completion:*' menu select

# Print the catagories the completion options fit into.
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'

# Set format for warnings
zstyle ':completion:*:warnings' format 'Sorry, no matches for: %d%b'

# Use colors when outputting file names for completion options.
zstyle ':completion:*' list-colors ''

# Do not prompt to cd into current directory.
# For example, cd ../<tab> should not prompt current directory.
zstyle ':completion:*:cd:*' ignore-parents parent pwd

# When using history-complete-(newer/older), complete with the first item on
# the first request (as opposed to 'menu select' which only shows the menu on
# the first request)
zstyle ':completion:history-words:*' menu yes

bindkey '^[[Z' reverse-menu-complete


# ==============================================================================
# = functions and zle widgets =
# ==============================================================================
#
# ------------------------------------------------------------------------------
# - zle widgets -
# ------------------------------------------------------------------------------
#
# The ZLE widges are all followed by "zle -<MODE> <NAME>" and bound below in
# the "Key Bindings" section.

# Prepend "sudo" to the command line if it is not already there.
prepend-sudo() {
	if ! echo "$BUFFER" | grep -q "^sudo "
	then
		BUFFER="sudo $BUFFER"
		CURSOR+=5
	fi
}
zle -N prepend-sudo

# Prepend "vim" to the command line if it is not already there.
prepend-vim() {
	if ! echo "$BUFFER" | grep -q "^vim "
	then
		BUFFER="vim $BUFFER"
		CURSOR+=5
	fi
}
zle -N prepend-vim

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# other custom functions
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# cd into a directory then immediately ls
cds() {
	cd $1 && ls
}

brb() {
	slock & sudo pm-suspend;
}

capstone-dev() {
	cd $HOME/capstone/mypharmacist-web;
	source venv/bin/activate
}


# ==============================================================================
# = key bindings =
# ==============================================================================

# temporarily save line contents
bindkey "^Y" push-line

# prepend sudo
bindkey "^S" prepend-sudo

# prepend vim
bindkey "^V" prepend-vim

# ==========================================================================
# environmental variables
# ==========================================================================
#
# ------------------------------------------------------------------------------
# - general (evironmental variables) -
# ------------------------------------------------------------------------------

# "/bin/zsh" should be the value of $SHELL if this config is parsed. This line
# should not be necessary, but it's not a bad idea to have just in case.
export SHELL="/bin/zsh"

# Set the default text editor.
export EDITOR="vim"

if [[ -z $DISPLAY ]]; then
	export BROWSER="elinks"
else
	export BROWSER="firefox"
fi

# If in a terminal that can use 256 colors, ensure TERM reflects that fact.
if [ "$TERM" = "xterm" ]
then
	export TERM="xterm-256color"
elif [ "$TERM" = "screen" ]
then
	export TERM="screen-256color"
fi

# set PDF reader
export PDFREADER="evince"
export PDFVIEWER="evince"

# Set the default image viewer.
export IMAGEVIEWER="google-chrome"

# sets mail directory
export MAIL="~/.mail"

export TZ="America/New_York"


# ------------------------------------------------------------------------------
# - prompt (environmental variables) -
# ------------------------------------------------------------------------------
#

autoload -U colors && colors

if [[ "$EUID" == "0" ]]; then
	export PROMPT="%{$fg_bold[blue]%}[%{$fg_bold[red]%}%n%{$reset_color%}@%{$fg[green]%}%m%{$fg_bold[blue]%}] [%{$reset_color%}%{$fg[green]%}%~%{$fg_bold[blue]%}]%{$reset_color%}
# "
else
	export PROMPT="%{$fg_bold[blue]%}[%{$fg_bold[green]%}%n%{$reset_color%}%{$fg[green]%}@%m%{$fg_bold[blue]%}] [%{$reset_color%}%{$fg[green]%}%~%{$fg_bold[blue]%}]%{$reset_color%}
\$ "
	#export PROMPT=$'%{\e[0;36m%}%n@%m:%~'\$$'%{\e[0m%} '
fi

# ==============================================================================
# = aliases =
# ==============================================================================

# ------------------------------------------------------------------------------
# - new commands (aliases) -
# ------------------------------------------------------------------------------

# Clear the screen then run `ls`
alias cls="clear;ls"

# Search entire filesystem and ignore errors
#alias finds="find / -name 2>/dev/null"

# Take ownership of file or directory
#alias mine="sudo chown -R $(whoami):$(whoami)"

# allow others to read/execute
#alias yours="sudo find . -perm -u+x -exec chmod a+x {} \; && sudo find . -perm -u+r -exec chmod a+r {} \;"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# set default flags
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

alias ls="ls --color=auto -h --group-directories-first"


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# wumbo
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
export wumbo=1


# rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
