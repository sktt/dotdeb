UNAME_S := $(shell uname -s)

# Wayland compositor, status bar and notification daemon. Linux only.
LINUX_ONLY_CONF := dot/config/sway dot/config/mako dot/config/yambar

# launchagents is installed by its own target, not symlinked into ~.
DOTFILES := $(filter-out dot/config dot/launchagents, $(wildcard dot/*))
DOTCONF  := $(wildcard dot/config/*)
BINFILES := $(wildcard bin/*)

ifeq ($(UNAME_S),Darwin)
  DOTCONF := $(filter-out $(LINUX_ONLY_CONF), $(DOTCONF))
  FONTDIR := $(HOME)/Library/Fonts
else
  FONTDIR := $(HOME)/.local/share/fonts
endif

# -n rather than GNU-only -T: if the link name is already a symlink to a
# directory, replace it instead of creating the link inside it. Both GNU
# coreutils and BSD/macOS ln understand -n.
LN := ln -fsn

.PHONY: symlinks
symlinks:
	@mkdir -p "$(HOME)/.config" "$(HOME)/.vim/spell"
	@for f in $(DOTFILES); do \
		$(LN) "$(CURDIR)/$$f" "$(HOME)/.$${f#dot/}" || exit 1; \
	done
	@for f in $(DOTCONF); do \
		$(LN) "$(CURDIR)/$$f" "$(HOME)/.config/$${f#dot/config/}" || exit 1; \
	done
	@# helper scripts the configs shell out to (launchagent, muttrc)
	@mkdir -p "$(HOME)/bin"
	@for f in $(BINFILES); do \
		$(LN) "$(CURDIR)/$$f" "$(HOME)/bin/$${f#bin/}" || exit 1; \
	done
	@# vim and nvim share one personal spelling wordlist
	@$(LN) "$(CURDIR)/dot/config/nvim/spell/en.utf-8.add" "$(HOME)/.vim/spell/en.utf-8.add"
ifeq ($(UNAME_S),Darwin)
	@echo "Darwin: skipped $(LINUX_ONLY_CONF)"
endif
	@ls -l "$(HOME)/.config"

.PHONY: fonts
fonts:
	@mkdir -p "$(FONTDIR)"
	cp fonts/*.ttf "$(FONTDIR)/"
ifneq ($(UNAME_S),Darwin)
	fc-cache -f "$(FONTDIR)"
endif

.PHONY: packages
ifeq ($(UNAME_S),Darwin)
packages:
	@command -v brew > /dev/null || { echo "install homebrew first: https://brew.sh"; exit 1; }
	brew install $$(grep -v '^\#' packages/brew.list | grep . | tr '\n' ' ')
	@# --adopt: take over an app already in /Applications instead of erroring
	brew install --cask --adopt $$(grep -v '^\#' packages/brew-cask.list | grep . | tr '\n' ' ')
else
packages:
	sudo apt-get update
	sudo apt-get install $$(grep -v '^\#' packages/apt.list | grep . | tr '\n' ' ')
endif

.PHONY: node
node: NVM := $(HOME)/.nvm/nvm.sh
node:
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
	. $(NVM) && nvm install stable && nvm alias default stable

.PHONY: ruby
ruby: packages
ruby:
	rbenv install -s "$$(rbenv install -l 2>/dev/null | grep -v - | tail -1)"
	rbenv global "$$(rbenv install -l 2>/dev/null | grep -v - | tail -1)"
	rbenv rehash

.PHONY: shell
shell: packages
shell:
	@command -v git > /dev/null
	@command -v zsh > /dev/null
	[ -d "$(HOME)/.oh-my-zsh" ] || \
		git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$(HOME)/.oh-my-zsh"
	@# macOS requires the login shell to be listed in /etc/shells
	grep -qx "$$(command -v zsh)" /etc/shells || \
		echo "$$(command -v zsh)" | sudo tee -a /etc/shells
	chsh -s "$$(command -v zsh)"
	@$(MAKE) --no-print-directory zsh-plugins

# zshrc's plugins=(...) list names two plugins oh-my-zsh does not ship.
# They live under $ZSH_CUSTOM/plugins, cloned rather than vendored here.
.PHONY: zsh-plugins
zsh-plugins: CUSTOM := $(HOME)/.oh-my-zsh/custom/plugins
zsh-plugins:
	@mkdir -p "$(CUSTOM)"
	@[ -d "$(CUSTOM)/zsh-syntax-highlighting" ] || git clone --depth=1 \
		https://github.com/zsh-users/zsh-syntax-highlighting.git \
		"$(CUSTOM)/zsh-syntax-highlighting"
	@[ -d "$(CUSTOM)/zsh-autosuggestions" ] || git clone --depth=1 \
		https://github.com/zsh-users/zsh-autosuggestions.git \
		"$(CUSTOM)/zsh-autosuggestions"

# tmux.conf's last line runs tpm, which manages the @plugin list above it.
# Only tpm is cloned here; tpm installs the rest. Test for the script, not the
# directory, so an empty leftover submodule dir doesn't count as installed.
.PHONY: tmux-plugins
tmux-plugins: TPLUG := $(CURDIR)/dot/tmux/plugins
tmux-plugins:
	@[ -x "$(TPLUG)/tpm/tpm" ] || { rm -rf "$(TPLUG)/tpm" && git clone --depth=1 \
		https://github.com/tmux-plugins/tpm.git "$(TPLUG)/tpm"; }
	@# install_plugins asks a running server for the config; use a throwaway one
	tmux -L tpm-install -f "$(CURDIR)/dot/tmux.conf" new-session -d
	tmux -L tpm-install run-shell "$(TPLUG)/tpm/bin/install_plugins"; \
		rc=$$?; tmux -L tpm-install kill-server; exit $$rc

# UltiSnips runs on nvim's python3 provider. A dedicated venv keeps pynvim
# off the system python; init.lua uses it when present.
.PHONY: nvim-python
nvim-python: VENV := $(HOME)/.local/share/nvim/venv
nvim-python:
	[ -x "$(VENV)/bin/python3" ] || python3 -m venv "$(VENV)"
	"$(VENV)/bin/pip" install -q --upgrade pynvim

# macOS only, opt-in: launchd needs absolute paths and a real file, so fill
# in $HOME and copy rather than symlink. The agents run scripts from ~/bin.
.PHONY: launchagents
launchagents: AGENTS := $(HOME)/Library/LaunchAgents
launchagents:
	@mkdir -p "$(AGENTS)"
	@for f in dot/launchagents/*.plist; do \
		dst="$(AGENTS)/$${f##*/}"; \
		sed 's#@HOME@#$(HOME)#g' "$$f" > "$$dst" || exit 1; \
		launchctl bootout gui/$$(id -u) "$$dst" 2>/dev/null; \
		launchctl bootstrap gui/$$(id -u) "$$dst" && echo "loaded $$dst"; \
	done

.PHONY: all
.DEFAULT: symlinks
all: packages shell node ruby fonts tmux-plugins nvim-python symlinks
