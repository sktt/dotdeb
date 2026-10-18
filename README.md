# dotdeb

Personal dotfiles. `make symlinks` links everything under `dot/*` and
`dot/config/*` into `~/.*` / `~/.config/*`, and `bin/*` into `~/bin/*`.

## Keyboard shortcuts cheat sheet

Easy to forget these exist since they live in config, not in any UI. Kept
here so future-me doesn't have to rediscover them.

| Shortcut | Effect | Where it's configured |
|---|---|---|
| `Alt+f` / `Alt+b` | Jump forward/back one word in the shell | zsh default emacs keymap (`dot/zshrc`, `bindkey -e`) + `option_as_alt = "OnlyLeft"` in `dot/config/alacritty/alacritty.toml` so left Option sends Meta/Esc |
| `Alt+.` | Insert last word of previous command | Same as above (zsh built-in `insert-last-word`) |
| `Caps Lock` | Remapped to `Escape` | Karabiner-Elements, `~/.config/karabiner/karabiner.json` simple_modifications (not yet tracked in this repo) |
| Volume up/down | Runs `ua_solo.sh volup` / `voldn` instead of system volume | Karabiner-Elements complex modification → `bin/ua_solo.sh` |
| Mute key | Runs `ua_solo.sh mute` | Karabiner-Elements complex modification → `bin/ua_solo.sh` |

Note: only the *left* Option key acts as Meta (`option_as_alt = "OnlyLeft"`).
If using the right Option key, these won't fire — change that setting to
`"Both"` if that's wanted.

Karabiner's `karabiner.json` itself isn't tracked here yet (it's machine-local
state Karabiner rewrites constantly) — the rules above are recorded here as
the durable reference instead.
