.DEFAULT_GOAL = help

export SHELL = /bin/bash
export PATH = .:${HOME}/.cabal/bin:${HOME}/.ghcup/bin:/usr/local/bin:/usr/bin:/bin

BIN ?= ddb

dev: clean ## build continuously
	@cabal new-build 2>&1 | source-highlight --src-lang=haskell --out-format=esc
	@fswatcher --path . \
	   	   --include "\.hs$$|\.cabal$$" \
		   --throttle 31 \
		   cabal new-build 2>&1 \
	| source-highlight --src-lang=haskell --out-format=esc

dev-ghcid: clean ## build continuously using ghcid
	@ghcid --command="cabal new-repl -fwarn-unused-binds -fwarn-unused-imports -fwarn-orphans" \
	       --reload=app/lamha.hs \
	       --restart=lamha.cabal \
	| source-highlight --src-lang=haskell --out-format=esc

build: clean # lint (breaks on multiple readers) ## build
	cabal new-build

test: ## test
	cabal new-test

lint: ## lint
	hlint app src

clean: ## clean
	cabal new-clean

run: ## run main, default: BIN=lamha
	cabal new-run ${BIN}

repl: ## repl
	cabal new-repl

help: ## help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	 | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-18s\033[0m %s\n", $$1, $$2}'
	@ghc --version
	@cabal --version
	@hlint --version
	@ghcid --version

init: ## initialize project
	${MAKE} -f etc/init.mk init
	[ -e "/usr/local/var/postgres" ] || ${MAKE} -f etc/db.mk init

update: ## update project depedencies
	${MAKE} -f etc/init.mk install-pkgs

SCHEMA=schema

migrate: CONNECTION="host=localhost dbname=log user=log"
migrate: ## update DB schema
	migrate init $(CONNECTION)
	migrate migrate $(CONNECTION) $(SCHEMA)

migrate-test: CONNECTION="host=localhost dbname=log_test user=log"
migrate-test: ## update test-DB schema
	migrate init $(CONNECTION)
	migrate migrate $(CONNECTION) $(SCHEMA)

migration-stub: DATE := $(shell date '+%s')
migration-stub: ## generate a DB migration stub
	touch schema/$(DATE).sql
# echo "module Db.Migration.Mig$(DATE) where" > src/Db/Migration/Mig$(DATE).hs







































































# colors
NON = \033[0m
RED = \033[1;31m
GRN = \033[1;32m
BLU = \033[1;34m
MAG = \033[1;35m
CYN = \033[1;36m
