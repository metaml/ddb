.DEFAULT_GOAL = help

GHC_VERSION ?= 8.8.3

export SHELL = /bin/bash
export PATH = ${HOME}/.cabal/bin:${HOME}/.ghcup/bin:/usr/local/bin:/usr/bin:/bin

NEW_INSTALL_OPT ?= --allow-newer --overwrite-policy=always

init: install-ghcup install-ghc install-pkgs ## install projects dependencies

install-ghcup: install-ghcup-deps  ## install ghcup
	curl https://raw.githubusercontent.com/haskell/ghcup/master/bootstrap-haskell -sSf | sh

install-ghc: ## install ghc
	ghcup install $(GHC_VERSION)
	ghcup set $(GHC_VERSION)
	ghcup install-cabal

install-pkgs: ## install hackage binaries
	cabal v2-install ${NEW_INSTALL_OPT} alex happy
	cabal v2-install ${NEW_INSTALL_OPT} fswatcher
	cabal v2-install ${NEW_INSTALL_OPT} ghcid
	cabal v2-install --overwrite-policy=always hlint
	cabal v2-install ${NEW_INSTALL_OPT} postgresql-simple-migration

install-ghcup-deps: ## install ghcup dependencies--@todo: use nix
	sudo apt update -y
	sudo apt upgrade -y
	for i in libpq-dev libc-bin curl coreutils gcc libgmp-dev libnuma-dev libtinfo-dev zlib1g-dev xz-utils zip; do \
		sudo apt install -y $$i; \
	done
	# brew update
	# brew upgrade
	# brew install curl coreutils gcc@8 gmp make ncurses python3 source-highlight xz
	# - brew unlink gcc@7
	# brew unlink gcc@8 && brew link gcc@8

cabal-update: ## cabal update
	cabal v2-update
	cabal v2-install ${NEW_INSTALL_OPT} --lib Cabal
	cabal v2-install ${NEW_INSTALL_OPT} cabal-install

cabal-config: ## user cabal config
	cabal user-config update

help: ## help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-18s\033[0m %s\n", $$1, $$2}'
