.PHONY: symlinks
symlinks: DOTFILES := $(wildcard dot/*)
symlinks:
	@for f in $(DOTFILES); do \
	 	ln -fs `pwd`/$$f ~/`echo $$f | sed s/dot\\\//./`; \
	done;
	@ls -lG `find ~ -maxdepth 1 -type l -print`

.PHONY: packages
packages: PACKAGES := $(shell cat ./packages/apt.list)
packages:
	sudo apt-get update
	sudo apt-get install $(PACKAGES)

.PHONY: node
node: packages
node: NVM := /usr/local/opt/nvm/nvm.sh
node:
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
	$(NVM) install stable
	$(NVM) alias default stable

.PHONY: ruby
ruby: packages
ruby: LATEST_STABLE := $(shell rbenv install -l | grep -v - | tail -1)
ruby:
	rbenv install $(LATEST_STABLE)
	rbenv global $(LATEST_STABLE)
	rbenv rehash

.PHONY: shell
shell: packages
shell:
	@which git > /dev/null
	@which zsh > /dev/null
	git clone --depth=1 git@github.com:robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
	chsh -s `which zsh`

.PHONY: all
.DEFAULT: all
all: packages node ruby shell symlinks
