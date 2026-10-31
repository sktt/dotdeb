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

## WeeChat + ZNC

WeeChat talks to ZNC (on `yesbox`, 10.0.0.3) over **plaintext IRC inside
WireGuard** — `10.0.0.3/6667`, `tls off`. WireGuard already encrypts the hop,
so IRC-level TLS was redundant there. ZNC's *upstream* connections to the IRC
networks keep TLS (`+6697`/`+7000`, `TrustPKI = true`) and are untouched.

`red-dir` is a direct connection to `irc.scratch-network.net`, not a ZNC
entry — it is deliberately left on its own settings.

### Per-machine client-id

Each machine identifies itself to ZNC with its hostname, so every device gets
its own buffer playback position:

    dot/zshenv:  export ZNC_CLIENTID="${ZNC_CLIENTID:-$(hostname -s)}"
    irc.conf:    username = "jnes@${env:ZNC_CLIENTID}/<znc-network>"

That is why one shared `irc.conf` works on every machine. Override
`ZNC_CLIENTID` in `~/.zshenv.local` if a host needs a different name.

### Secrets

No password is in any tracked file. The ZNC password lives in WeeChat's
`sec.conf` (AES-256), and `sec.conf`'s passphrase comes from `pass`:

    sec.crypt.passphrase_command = "pass show weechat/secure"
    irc.server.<name>.password   = "${sec.data.znc}"

`sec.conf` itself is **gitignored** — it re-encrypts with a fresh salt on
every save, so sharing it through git would churn and conflict. Recreate it
once per machine (needs `pass` + the GPG key present):

    /secure passphrase <paste: pass show weechat/secure>
    /secure set znc <paste: pass show znc/jnes>
    /set sec.crypt.passphrase_command "pass show weechat/secure"
    /save

`pass` entries used: `weechat/secure`, `znc/jnes`.

### Logs

`logger.file.path` points at `${env:HOME}/.local/share/weechat/logs/`, not
`%h/logs`, to keep ~580MB of scrollback out of the repo.

## Keyboard shortcuts cheat sheet

Easy to forget these exist since they live in config, not in any UI.

| Shortcut | Effect | Where it's configured |
|---|---|---|
| `Alt+f` / `Alt+b` | Jump forward/back one word in the shell | zsh default emacs keymap (`dot/zshrc`, `bindkey -e`) + `option_as_alt` in `dot/config/alacritty/alacritty.toml` so Option sends Meta/Esc |
| `Alt+.` | Insert last word of previous command | Same as above (zsh built-in `insert-last-word`) |
| `Caps Lock` | Remapped to `Escape` | Karabiner-Elements (`~/.config/karabiner/karabiner.json`, not tracked here — machine-local state Karabiner rewrites constantly) |
| Volume up/down/mute | Runs `~/bin/ua_solo.sh volup`/`voldn`/`mute` instead of system volume | Karabiner-Elements complex modification |

### tmux (prefix = `C-Space`)

`prefix+H` opens a popup with the full list (`dot/tmux/cheatsheet.sh`). Highlights:

| Key | Effect |
|---|---|
| `N` | Break the active pane into a brand-new session (prompts for name) |
| `W` | Move the current window to another session, picked from a visual list |
| `r` | Reload `tmux.conf` |
| `n` | Rename window |
| `m`/`M`/`t`/`h`/`v` | Layout: main-vertical / main-horizontal / tiled / even-horizontal / even-vertical |

## Not in this repo

- Secrets. Mail passwords come from [`pass`](https://www.passwordstore.org/)
  via `PassCmd`/backticks; `*.p12`, `*.pem`, `*.key` and `*.gpg` are gitignored.
- `~/bin` helper scripts referenced by some configs but not themselves useful
  outside this machine's setup (`mailcount`, `languagetool`, `vale`,
  `fade-layer`). `mailsync`, `debounce` and `ua_solo.sh` **are** tracked, in
  `bin/`.
- The mail stack needs `pass`, `gnupg` and a `~/Mail/gmail` maildir before
  neomutt/notmuch will do anything useful. `notmuch-config` uses a
  `$HOME`-relative path so it works unchanged on both platforms.
