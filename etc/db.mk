.DEFAULT_GOAL = help

export SHELL = /bin/bash
export PATH = /usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin

DB ?= log

init: ## all targets
init: install create extension stop sleep start

create: ## create test database
create: init-db start sleep create-db

start: ## start postgresql
	pgrep -i postgres || ( pg_ctl start -D /usr/local/var/postgres | tee /tmp/$@.log ) &

stop: ## stop postgresql
	pg_ctl stop -D /usr/local/var/postgres


install: ## install postgresql
	brew update
	brew install openssl readline postgresql
	brew link --overwrite postgresql

init-db: ## init DB
	initdb /usr/local/var/postgres -E utf8 --auth-local trust

create-db: ## create roles and DBs
	- createuser --superuser --createrole --createdb --echo postgres
	- createuser --superuser --createrole --createdb --echo ${DB}
	createdb --owner=postgres --encoding=UTF8 --lc-collate=en_US.UTF-8 --lc-ctype=en_US.UTF-8 ${DB}
	createdb --owner=postgres --encoding=UTF8 --lc-collate=en_US.UTF-8 --lc-ctype=en_US.UTF-8 ${DB}_test

EXTENSIONS = uuid-ossp fuzzystrmatch pg_trgm
extension: ## apply DB extensions
	for i in ${EXTENSIONS}; do \
		psql -Upostgres ${DB}      --command "create extension if not exists \"$${i}\""; \
		psql -Upostgres ${DB}_test --command "create extension if not exists \"$${i}\""; \
	done

clobber: ## kill postgresql and delete dir
	- pkill postgres
	rm -rf /usr/local/var/postgres

help: ## help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-18s\033[0m %s\n", $$1, $$2}'

sleep:; sleep 5
