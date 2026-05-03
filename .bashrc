# ~/.bashrc — backup shell. Mirrors ~/.zshrc as closely as bash allows.
# Kept bash-3.2 compatible so it runs on stock macOS bash.

# Bail out if not interactive
[ -z "$PS1" ] && return

# ------------------------------------------------------------------------------
# History (mirrors zsh HISTSIZE/SAVEHIST)
# ------------------------------------------------------------------------------
HISTCONTROL=ignoreboth
HISTSIZE=10000
HISTFILESIZE=10000
shopt -s histappend checkwinsize

# ------------------------------------------------------------------------------
# Vi mode (mirrors zsh `bindkey -v`)
# ------------------------------------------------------------------------------
set -o vi

# ------------------------------------------------------------------------------
# Prompt — colored bracketed style, red-username if root
# ------------------------------------------------------------------------------
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

force_color_prompt=yes
if [ -n "$force_color_prompt" ] && [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    color_prompt=yes
else
    color_prompt=no
fi

BGREEN='\[\033[1;32m\]'
GREEN='\[\033[0;32m\]'
BRED='\[\033[1;31m\]'
BBLUE='\[\033[1;34m\]'
NORMAL='\[\033[00m\]'

if [ "$color_prompt" = yes ]; then
    if [ "$UID" -eq 0 ]; then
        PS1="${BBLUE}[${BRED}\u${GREEN}@\h${BBLUE}] ${BBLUE}[${GREEN}\w${BBLUE}] ${NORMAL}\n# "
    else
        PS1="${BBLUE}[${BGREEN}\u${GREEN}@\h${BBLUE}] ${BBLUE}[${GREEN}\w${BBLUE}] ${NORMAL}\n\$ "
    fi
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# xterm title: user@host: dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
esac

# ------------------------------------------------------------------------------
# Editor / browser (match zsh)
# ------------------------------------------------------------------------------
export EDITOR="vim"
export BROWSER="firefox"

# ------------------------------------------------------------------------------
# Wumbo
# ------------------------------------------------------------------------------
export wumbo=1

# ==============================================================================
# = paths and tool activations (portable: Linux + macOS) =
# ==============================================================================

# pipx user bin
[ -d "$HOME/.local/bin" ] && export PATH="$PATH:$HOME/.local/bin"

# mise (only if installed)
if command -v mise >/dev/null 2>&1; then
    eval "$(mise activate bash)"
fi

# Cross-platform ls flags (BSD on macOS, GNU on Linux)
if [ "$(uname)" = "Darwin" ]; then
    alias ls="ls -Gh"
else
    alias ls="ls --color=auto -h --group-directories-first"
fi

# Homebrew (macOS, only if installed)
[ -x /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"

# Bash completion (Debian path; macOS users typically install via brew)
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# Per-host overrides (kept outside the repo)
[ -f "$HOME/.bashrc.local" ] && source "$HOME/.bashrc.local"
