# dotfiles

Personal configuration for Debian/Linux and macOS from one branch.

## Install

```sh
git clone git@github.com:sktt/dotdeb.git ~/dotdeb
cd ~/dotdeb
make packages   # apt on Linux, homebrew on macOS
make shell      # oh-my-zsh + chsh
make symlinks   # link everything into ~
make fonts      # optional: M+ fonts
```

`make all` runs the lot.

## Layout

| Path | Linked to |
| --- | --- |
| `dot/<name>` | `~/.<name>` |
| `dot/config/<name>` | `~/.config/<name>` |

`make symlinks` derives both from the directory listing, so a new file in
`dot/` needs no Makefile change.

## How the two platforms share one branch

The Makefile branches on `uname -s`:

- **Packages** come from `packages/apt.list` on Linux, and
  `packages/brew.list` + `packages/brew-cask.list` on macOS.
- **`dot/config/sway`, `mako` and `yambar` are skipped on macOS** — they are a
  Wayland compositor, notification daemon and status bar, with no counterpart
  there. Everything else is linked on both.
- **Fonts** land in `~/.local/share/fonts` (plus `fc-cache`) on Linux and
  `~/Library/Fonts` on macOS.
- `ln -fsn`, not GNU-only `ln -T`, so BSD/macOS `ln` accepts it.

Shell config is split three ways, sourced in this order:

```
~/.zshenv   -> ~/.zshenv.$(uname -s)   -> ~/.zshenv.local
~/.zshrc    -> ~/.zshrc.$(uname -s)    -> ~/.zshrc.local
```

The shared file holds everything portable. `.Linux`/`.Darwin` hold what differs
— `batcat` vs `bat`, `wl-copy`/`xclip` vs `pbcopy`, GNU vs LLVM `objdump`,
autojump's install path, Homebrew's `shellenv` and GNU coreutils on `PATH`.
`.local` is gitignored, for one machine only; `~/.gitconfig.local` is the same
idea for git.

`tmux.conf` and `vimrc` use in-file conditionals (`if-shell`, `isdirectory()`)
rather than separate files.

## Not in this repo

- Secrets. Mail passwords come from [`pass`](https://www.passwordstore.org/)
  via `PassCmd`/backticks; `*.p12`, `*.pem`, `*.key` and `*.gpg` are gitignored.
- `~/bin` helper scripts referenced by some configs (`mailcount`, `languagetool`,
  `vale`, `fade-layer`).
- The mail stack needs `pass`, `gnupg` and a `~/Mail/gmail` maildir before
  neomutt/notmuch will do anything useful. `notmuch-config` uses a
  `$HOME`-relative path so it works unchanged on both platforms.
