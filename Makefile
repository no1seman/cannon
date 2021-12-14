SHELL := /bin/bash

.PHONY: all
all: stop clean bootstrap migrations

.PHONY: .rocks
.rocks:
		./deps.sh
		tarantoolctl rocks make

.PHONY: bootstrap
bootstrap:
		@ if [ ! -d "./.rocks" ]; then make .rocks; fi
		cartridge start -d --stateboard
		@ sleep 20s
		cartridge replicasets setup --file ./replicasets.yml --bootstrap-vshard
		@ sleep 5s

.PHONY: start
start:
		cartridge start -d --stateboard
		@ sleep 5s

.PHONY: stop
stop:
		cartridge stop --stateboard
		@ sleep 5s

.PHONY: migrations
migrations:
		@ curl -X POST http://localhost:8081/migrations/up

.PHONY: clean
clean:
		@ rm -rf ./tmp/data && rm -rf ./tmp/log && rm -rf ./tmp/run

.PHONY: clean-rocks
clean-rocks:
		@ rm -rf .rocks

.PHONY: build
build:
		cartridge pack rpm --version 0.0.1 --use-docker
