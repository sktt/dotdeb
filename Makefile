UNAME_S := $(shell uname -s)

# Wayland compositor, status bar and notification daemon. Linux only.
LINUX_ONLY_CONF := dot/config/sway dot/config/mako dot/config/yambar

DOTFILES := $(filter-out dot/config, $(wildcard dot/*))
DOTCONF  := $(wildcard dot/config/*)

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
	brew install --cask $$(grep -v '^\#' packages/brew-cask.list | grep . | tr '\n' ' ')
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

.PHONY: all
.DEFAULT: symlinks
all: packages shell node ruby fonts symlinks
