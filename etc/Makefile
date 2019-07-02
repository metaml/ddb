.DEFAULT_GOAL = help

export SHELL = /bin/bash
export PATH = .:${HOME}/.cabal/bin:${HOME}/.ghcup/bin:/usr/local/bin:/usr/bin:/bin

db-docker: ## build db-docker image
	docker build --file db.docker --tag db:latest .

help: ## help
	@grep -E '^[a-zA-Z00-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-18s\033[0m %s\n", $$1, $$2}'
