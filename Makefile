#
#  Author: Hari Sekhon
#  Date: [% DATE # 2013-01-06 10:39:34 +0000 (Sun, 06 Jan 2013) %]
#
#  vim:ts=4:sts=4:sw=4:noet
#
#  [% URL %]
#
#  [% MESSAGE %]
#
#  [% LINKEDIN %]
#

# For serious Makefiles see the DevOps Bash tools repo:
#
#	https://github.com/HariSekhon/DevOps-Bash-tools
#
#	Makefile
#	Makefile.in - generic include file with lots of Make targets


# only works in GNU make - is ignored by Mac's built-in make - not portable, should avoid and call bash scripts instead
#.ONESHELL:
# make oneshell exit on first error
#.SHELLFLAGS = -e

SHELL = /usr/bin/env bash

PATH := $(PATH):$(PWD)/bash-tools

RELEASE := v1

.PHONY: default
default:
	@echo "running default build:"
	$(MAKE) build

.PHONY: build
build: init
	@echo "running build:"

.PHONY: init
init:
	@echo "running init:"
	if type -P git; then git submodule update --init --recursive; fi
	@echo

.PHONY: bash-tools
bash-tools:
	@if ! command -v check_pytools.sh; then \
		curl -L https://git.io/bash-bootstrap | sh; \
	fi

.PHONY: test
test: bash-tools
	@echo "running tests:"
	check_pytools.sh

.PHONY: tests
tests: test
	@:

release:
	@echo "Releasing $(RELEASE)"
	git tag --force $(RELEASE)
	git push --tags --force

# ============================================================================ #
#                 S k a f f o l d   f o r   K u b e r n e t e s
# ============================================================================ #

#.PHONY: *

run:
	skaffold run --label skaffold.dev/run-id="static"

dev:
	skaffold dev --cleanup=false --label skaffold.dev/run-id="static"

delete:
	skaffold delete
