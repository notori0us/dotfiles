# With great thanks and credit to Paradigm and his wonderfully crafted .zshrc
# https://github.com/paradigm/dotfiles/blob/master/.zshrc

HISTFILE=~/.history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

# ==============================================================================
# = paths and tool activations (portable: Linux + macOS) =
# ==============================================================================
# Runs before compinit so brew's site-functions and mise tools are on fpath/PATH.

# de-duplicate PATH/fpath entries (login shells may have added some already)
typeset -U path fpath

# Homebrew (macOS; Apple Silicon or Intel)
for _brew in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    [ -x "$_brew" ] && { eval "$("$_brew" shellenv)"; break; }
done
unset _brew

# user bin (mise, pipx, hand-installed tools)
path=("$HOME/.local/bin" $path)

# mise (only if installed)
if command -v mise >/dev/null 2>&1; then
    eval "$(mise activate zsh)"
fi

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
[[ -t 0 ]] && stty -ixon

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
CACHEDIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
[ -d "$CACHEDIR" ] || mkdir -p "$CACHEDIR"

# Use completion functionality. -i: skip insecure dirs (brew on macOS) quietly.
autoload -Uz compinit
compinit -i -d "$CACHEDIR/zcompdump"

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

# Set the default text editor.
export EDITOR="vim"


# If in a terminal that can use 256 colors, ensure TERM reflects that fact.
if [ "$TERM" = "xterm" ]
then
	export TERM="xterm-256color"
elif [ "$TERM" = "screen" ]
then
	export TERM="screen-256color"
fi

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
# wumbo
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
export wumbo=1


# ==============================================================================
# = portable aliases =
# ==============================================================================

# Cross-platform ls flags (BSD on macOS, GNU on Linux)
if [ "$(uname)" = "Darwin" ]; then
    alias ls="ls -Gh"
else
    alias ls="ls --color=auto -h --group-directories-first"
fi

# Per-host overrides (kept outside the repo)
if [ -f "$HOME/.zshrc.local" ]; then source "$HOME/.zshrc.local"; fi
