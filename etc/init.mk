.DEFAULT_GOAL = help

GHC_VERSION = 8.6.5

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

install-pkgs: cabal-update ## install hackage binaries
	cabal new-install ${NEW_INSTALL_OPT} cabal-install Cabal
	cabal new-install ${NEW_INSTALL_OPT} alex happy
	cabal new-install ${NEW_INSTALL_OPT} fswatcher ghcid hlint
	cabal new-install ${NEW_INSTALL_OPT} postgresql-simple-migration

install-ghcup-deps: ## install ghcup dependencies
	brew update
	brew upgrade
	brew install curl coreutils gcc@8 gmp make ncurses python3 source-highlight xz
	- brew unlink gcc@7
	brew unlink gcc@8 && brew link gcc@8

cabal-update: ## cabal update
	cabal new-update
	cabal new-install ${NEW_INSTALL_OPT} Cabal cabal-install

cabal-config: ## user cabal config
	cabal user-config update

help: ## help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-18s\033[0m %s\n", $$1, $$2}'
