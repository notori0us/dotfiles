==================
notori0us/dotfiles
==================

A small, hand-maintained set of personal config files for
zsh / bash / vim / tmux / git, currently in use on Debian Linux
and macOS.

Install
-------

Clone, then run::

    git clone https://github.com/notori0us/dotfiles.git ~/dotfiles
    cd ~/dotfiles && ./setup.sh

``setup.sh`` backs up any conflicting ``~/<dotfile>`` to ``~/backup/``,
symlinks each tracked dotfile into place, and bootstraps ``mise``
if it isn't already installed. Re-running is a no-op once the
``already_set_up`` marker exists. To restore the originals, run
``./teardown.sh``.

Per-host overrides
------------------

Anything host-specific (work env, secrets, machine-particular tweaks)
belongs in ``~/.zshrc.local`` and/or ``~/.bashrc.local``. Both are
sourced last by the respective rc files and are *not* tracked here.

Caveat
------

Version controlling dotfiles is a great idea — but be wary of
verbatim copying from someone else's repo. These settings are
tailored toward me.
