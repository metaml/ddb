.DEFAULT_GOAL = help

export SHELL = /bin/bash
export PATH = /usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin

DB ?= ddb

init: ## all targets
init: install create extension stop sleep start

create: ## create test database
create: init-db start sleep create-db

install: deps add-docker-gpg-key add-repo ## instal desiderata
	sudo apt update -y
	sudo apt install -y docker-ce docker-ce-cli containerd.io

deps: ## install dependendencies
	for i in apt-transport-https ca-certificates curl gnupg-agent software-properties-common; do \
		sudo apt install -y $$I; \
	done

add-docker-gpg-key: ## add GPG key
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

add-repo: ## add docker repo
	sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $$(lsb_release -cs) stable"

# docker run --name some-postgres -e POSTGRES_PASSWORD=mysecretpassword -d postgres
run: ## run a postgresql server
	docker run --detach --network=host --name ddb \
		--env DB_DBNAME=ddb \
		--env DB_PORT=5432 \
		--env DB_USER=ddb \
		--env DB_PASS=ddb \
		--env DB_HOST=127.0.0.1 \
		--env POSTGRES_PASSWORD=ddb \
		postgres

psql: ## connect to posgresql docker instance
	psql -hlocalhost -Upostgres postgres

clean: ## clean up docker
	- docker stop $$(docker ps --quiet)
	- docker rm $$(docker ps --all --quiet)

create-db: ## create roles and DBs
	- createuser --host=localhost --username=postgres --superuser --createrole --createdb --echo ${DB}
	createdb --host=localhost --username=postgres --owner=postgres --encoding=utf8 --lc-collate=en_US.utf8 --lc-ctype=en_US.utf8 ${DB}
	createdb --host=localhost --username=postgres --owner=postgres --encoding=utf8 --lc-collate=en_US.utf8 --lc-ctype=en_US.utf8 ${DB}_test

extension: ## apply DB extensions
	for i in uuid-ossp fuzzystrmatch pg_trgm; do \
		psql -hlocalhost -Upostgres ${DB}      --command "create extension if not exists \"$${i}\""; \
		psql -hlocalhost -Upostgres ${DB}_test --command "create extension if not exists \"$${i}\""; \
	done

clobber: ## kill postgresql and delete dir
	- pkill postgres
	rm -rf /usr/local/var/postgres

help: ## help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-18s\033[0m %s\n", $$1, $$2}'

sleep:; sleep 5
