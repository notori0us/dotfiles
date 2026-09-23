==================
notori0us/dotfiles
==================

Personal config for zsh / bash / vim / tmux / git / mise, in use on
Debian Linux and macOS. CI installs it into a scratch home on both
(``.github/workflows/ci.yml``).

Install
-------

::

    git clone git@github.com:notori0us/dotfiles.git ~/dotfiles
    cd ~/dotfiles && ./setup.sh
    mise install

``setup.sh`` symlinks every tracked dotfile into ``$HOME`` file by file,
moves anything it would overwrite into ``~/backup/dotfiles-<timestamp>/``,
and installs ``mise`` if missing (Homebrew on macOS, mise.run elsewhere).
It is safe to re-run.

``./setup.sh --check`` reports drift without changing anything and exits
non-zero if a link is missing, a file was replaced, or the clone is dirty
or out of sync. ``./teardown.sh --yes`` removes the links and restores
the newest backups.

Per-host overrides
------------------

Machine-specific settings live outside the repo:

* ``~/.zshrc.local`` / ``~/.bashrc.local``: sourced last by the rc files
* ``~/.gitconfig.local``: included by ``.gitconfig`` (work identity, safe.directory)
* ``~/.config/mise/conf.d/local.toml``: extra tools for this machine

Project toolchains belong in the project's own ``mise.toml``.

Agents
------

``AGENTS.md`` (also ``CLAUDE.md``) has the layout rules, invariants and a
runbook for migrating a machine that still has the old setup.

Caveat
------

Version controlling dotfiles is a great idea, but be wary of verbatim
copying from someone else's repo. These settings are tailored to me.
