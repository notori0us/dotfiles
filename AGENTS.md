# AGENTS.md: notori0us/dotfiles

Instructions for coding agents (Claude Code reads this via the `CLAUDE.md`
symlink). **This repo is public.** Never commit secrets, tokens, employer
names, internal hostnames, proxies, IPs or registry URLs.

## What this repo is

Personal shell/editor config for Chris, used on Debian Linux (`sagitta`, the
main dev box) and macOS (a work MacBook). Shells: zsh primary, bash as a
backup. Plus vim, tmux, git and mise.

## Layout and rules

- **Every tracked path starting with `.` is a home file.** `setup.sh` links it
  file by file to the same path under `$HOME`. The exceptions are repo
  plumbing: `.gitignore`, `.shellcheckrc` and `.github/`.
- **Paths without a leading dot are repo-only.** That covers `README.rst`,
  `AGENTS.md`, `setup.sh` and `teardown.sh`.
- **Per-file links, never directory links.** Older versions linked whole
  directories (`~/.vim`, `~/.config/<x>`). `setup.sh` "unfolds" those so tools
  never write into the repo.
- **One portable config, no per-host layer.** OS differences are handled
  inline with `uname` and `command -v` checks.

Where each kind of change belongs:

| Kind of change | Goes in |
|---|---|
| Wanted on every machine | this repo |
| One machine only (aliases, work env, PATH) | `~/.zshrc.local`, `~/.bashrc.local` (untracked) |
| Git settings for one machine (work identity, safe.directory) | `~/.gitconfig.local` (untracked, included by `.gitconfig`) |
| Extra global tools for one machine | `~/.config/mise/conf.d/local.toml` (untracked) |
| A project's toolchain | that project's `mise.toml` (sagitta's homelab uses `~/workspace/mise.toml`) |
| Secrets | nowhere in this repo |

## Commands

```sh
./setup.sh --check   # read-only drift report; exit 1 on drift
./setup.sh           # link/repair; conflicts go to ~/backup/dotfiles-<ts>/
./teardown.sh        # dry run; --yes removes links and restores newest backups
```

## Invariants (CI enforces most of these)

- **bash 3.2.** `setup.sh`, `teardown.sh` and `.bashrc` must run on stock
  macOS `/bin/bash` 3.2. That rules out `mapfile`, `declare -A`,
  `${var,,}` and `readlink -f`.
- **`.zshrc` order.** Homebrew shellenv, then `~/.local/bin`, then
  `mise activate`, then `compinit` last, so brew completions and mise tools are
  visible. There is exactly one `compinit`, cached in `~/.cache/zsh/`.
- **No tty assumptions.** Guard terminal-only commands with `[[ -t 0 ]]`. CI runs
  `zsh -i` headless and fails on any stderr.
- **Linux login files.** On Linux, don't add `~/.bash_profile`: it would stop
  bash from reading Debian's `~/.profile`. `~/.profile` is untracked and host-owned.
- **Tool pins.** Pin versions in mise configs. Ruby follows `.ruby-version`
  through `idiomatic_version_file_enable_tools`.

## Runbook: migrating a host that has the old setup

Use this on any machine cloned before the 2026-09 rework, such as the work
MacBook. Expect drift. **Survey read-only first and change nothing until
the drift is classified.**

1. **Find the clone and its state.**
   ```sh
   ls -la ~ ~/.config/* | grep -- '->'          # where do links point? usually ~/dotfiles
   cd ~/dotfiles && git remote -v && git status && git stash list
   git fetch && git log --oneline HEAD..@{u} | wc -l   # how far behind
   git log --oneline @{u}..HEAD                       # unpushed local commits
   ```
   Signs of an old setup: an `already_set_up` marker, `.vim/bundle` or
   pathogen, rbenv/chruby lines, `BROWSER=firefox`, or directory links such as
   `~/.vim -> ~/dotfiles/.vim`.
2. **Capture drift before pulling.** Save the evidence:
   `git diff > ~/backup/dotfiles-drift-$(date +%F).patch`. Drift hides in several places:
   - Uncommitted edits in the clone. Installers such as conda, nvm, pyenv,
     rbenv, gcloud, orbstack, Docker Desktop and iTerm append to `~/.zshrc`.
     If that file is a link, their lines land in the repo as a diff.
   - Home files that are real files instead of links (compare with `diff`).
   - Files the repo doesn't manage: `~/.zprofile` (Homebrew's installer puts
     `brew shellenv` there), `~/.zshenv`, `~/.bash_profile`, `~/.profile`.
   - Local commits never pushed.
3. **Classify every hunk** and write the classification down for the user:
   - *Universal and still wanted*: commit to the repo.
   - *Machine or work specific*: move to the `*.local` file for that tool.
   - *Installer boilerplate for a tool mise now manages* (rbenv, pyenv, nvm,
     asdf, tfenv): drop it, and list it in the report. Don't uninstall those
     tools without asking.
   - *Secrets*: move to a `*.local` file. If a secret was ever committed or
     pushed, stop and tell the user it needs rotating.
4. **Update.** Run `git stash`, then `git pull --rebase`. Re-apply only the
   universal hunks. Put the rest in `*.local` files.
5. **Link.** Run `./setup.sh --check` to preview. Then run `./setup.sh`, then
   `./setup.sh --check` again until it reports `OK`. Conflicting real files
   end up in `~/backup/dotfiles-<ts>/`. Diff those against the `*.local` files
   to confirm nothing was lost.
6. **Tools.** Run `mise install`. On macOS, `setup.sh` installs mise through
   Homebrew when brew is present.
7. **Verify in a new shell**:
   ```sh
   zsh -i -c exit                               # no output, no errors
   time zsh -i -c exit                          # well under 200 ms
   git config --global --list --show-origin     # identity + includes resolve
   vim -Nu ~/.vimrc -i NONE -es -c 'qa!'; echo $?   # 0
   tmux -f ~/.tmux.conf -L t new -d && tmux -L t kill-server
   ```
8. **Commit and push** the universal changes with a message that says what
   changed and why. Then report the classification from step 3 to the user.

Things specific to a **work machine**:
- **Git identity.** The tracked `.gitconfig` carries the personal identity. Set
  the work identity in `~/.gitconfig.local`, or use an `includeIf "gitdir:~/work/"`
  block there. Ask the user which email to use; never guess.
- **Managed files.** MDM may manage `/etc/zshrc` or proxies. Don't fight it,
  and don't copy its values into this repo.
- **Local only.** Work tools and settings go in `~/.config/mise/conf.d/local.toml`
  or the `*.local` files, never here.

## Decision log

- **2026-09 rework.** Per-file links, `--check` mode, no marker file, CI on
  Linux + macOS. A single cached `compinit` cut zsh startup from ~300 ms
  to ~60 ms. Tool pins moved into mise. On sagitta, the homelab CLIs moved to
  a directory-scoped `~/workspace/mise.toml`, replacing hand-dropped
  binaries and user-site pip.
- **Host layer rejected.** The only real difference between machines was
  whether the homelab checkout exists. mise's directory scoping already
  handles that.
- **Stay on plain shell scripts.** chezmoi and stow were rejected: the
  `*.local` hooks plus mise cover every per-machine difference, with no extra
  tool to bootstrap.
