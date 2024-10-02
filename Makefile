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

# parallelize
#MAKEFLAGS = -j2

SHELL = /usr/bin/env bash

.SHELLFLAGS += -eu -o pipefail

PATH := $(PATH):$(PWD)/bash-tools

# XXX: Edit
BINARY=go-binary-name

RELEASE := v1

.PHONY: default
default:  ## default if no arg target specified (runs build)
	@echo "running default build:"
	$(MAKE) build

.PHONY: build
build: init  ## run init and then build
	@echo "running build:"
	go build -o "$(BINARY)" main.go

.PHONY: gorun
gorun:
	go run main.go # harisekhon
	@#if uname -s | grep -q Darwin; then open graph.png; fi
	@#if uname -s | grep -q Darwin; then open graph.svg; fi

.PHONY: goupdates
goupdates:
	go get -u all
	go mod tidy

.PHONY: init
init:  ## run init to pull / update git submodules
	@echo "running init:"
	if type -P git; then git submodule update --init --recursive; fi
	@echo

.PHONY: bash-tools
bash-tools:  ## download and bootstrap HariSekhon/DevOps-Bash-tools
	@if ! command -v check_pytools.sh; then \
		curl -L https://git.io/bash-bootstrap | sh; \
	fi

.PHONY: test
test: bash-tools  ## run tests - download HariSekhon/DevOps-Bash-tools and run pytools tests
	@echo "running tests:"
	check_pytools.sh

.PHONY: tests
tests: test  ## run tests
	@:

.PHONY: push
push:  ## push to origin (usually GitHub)
	git push

# build a locally named obvious docker image with the git checkout dir and subdirectories for testing purposes
# -  with a tag of the Git Commit Short Sha hashref of this current commit +
# - a unique checksum of the list of files changed as a 'dirty' differentiator
# - to compare the different resulting docker image sizes from
# - the current commit's version of the Dockerfile
#     vs
# - the currently modified Dockerfile
.PHONY: docker-build-hashref
docker-build-hashref:  ## build a local docker image tagged with the hash
	set -euxo pipefail; \
	git_commit_short_sha="$$(git rev-parse --short HEAD)"; \
	git_root="$$(git rev-parse --show-toplevel)"; \
	git_root_dir="$${git_root##*/}"; \
	git_path="$${git_root_dir}/$${PWD##$$git_root/}"; \
	image_name="$${git_path////--}"; \
	dirty=""; \
	if git status --porcelain | grep -q . ; then \
		dirty="-dirty-$$(git status --porcelain | md5sum | cut -c 1-7)"; \
	fi; \
	docker build . -t "$${image_name}:$${git_commit_short_sha}$${dirty}" && \
	docker images | grep "^$$image_name"

.PHONY: packer-parallel
packer-parallel:
	for x in debian fedora ubuntu; do VBoxManage unregistervm "$$x" --delete 2>/dev/null || : ; done
	packer build --force template.pkr.hcl

.PHONY: packer
packer:  ## run all packer builds
	$(MAKE) debian
	@echo
	$(MAKE) ubuntu
	@echo
	$(MAKE) fedora
	@echo
	@echo "Linting passed"

.PHONY: debian
debian:  ## run debian packer build
	VBoxManage unregistervm debian --delete 2>/dev/null || :
	packer build --force --only=debian.* template.pkr.hcl

.PHONY: fedora
fedora:  ## run fedora packer build
	VBoxManage unregistervm fedora --delete 2>/dev/null || :
	packer build --force --only=fedora.* template.pkr.hcl

.PHONY: ubuntu
ubuntu:  ## run ubuntu packer build
	VBoxManage unregistervm ubuntu --delete 2>/dev/null || :
	packer build --force --only=ubuntu.* template.pkr.hcl

.PHONY: autoinstall-lint
autoinstall-lint:  ## lint ubuntu autoinstall cloud-init config
	docker run -ti -v "$$PWD:/pwd" -w /pwd -e DEBIAN_FRONTEND=noninteractive ubuntu:latest bash -c 'apt-get update && apt-get install cloud-init -y && echo && cloud-init schema --config-file autoinstall-user-data'

.PHONY: kickstart-lint
kickstart-lint:  ## lint redhat kickstart config
	docker run -ti -v "$$PWD:/pwd" -w /pwd fedora:latest bash -c 'dnf install pykickstart -y && ksvalidator anaconda-ks.cfg'

.PHONY: preseed-lint
preseed-lint:  ## lint debian preseed config
	docker run -ti -v "$$PWD:/pwd" -w /pwd -e DEBIAN_FRONTEND=noninteractive debian:latest bash -c 'apt-get update && apt-get install debconf -y && echo && debconf-set-selections -c preseed.cfg'

# if you really want to check it locally before pushing - otherwise just let the CI/CD workflows run and check the README badge statuses
.PHONY: lint
lint:  ## lint all automatic installer configs
	$(MAKE) autoinstall-lint
	@echo
	$(MAKE) kickstart-lint
	@echo
	$(MAKE) preseed-lint

.PHONY: clean
clean:  ## clean out temporary files (.class, .pyc, .pyo, .png, .svg, output-*, .checksum)
	@# buggy this doesn't work on mac, not even with -or and not even in gfind, so splitting up
	@#find . -name '*.class' -o -name '*.py[oc]' -o -name '*.png' -o -name '*.svg' -exec rm -v {} \;
	find . -name '*.class' -exec rm -v {} \;
	find . -name '*.py[oc]' -exec rm -v {} \;
	find . -name '*.png' -exec rm -v {} \;
	find . -name '*.svg' -exec rm -v {} \;
	@rm -frv -- output-* *.checksum

.PHONY: wc
wc:  ## count lines of all top level files
	 find . -maxdepth 1 -type f | xargs wc -l

.PHONY: release
release:  ## generate a git tag release and push tags
	@echo "Releasing $(RELEASE)"
	git tag --force $(RELEASE)
	git push --tags --force

# Prints the ## suffixed comment from each target to dynamically create a help listing, with colour
.PHONY: help
help: ## Show this help
	@egrep '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

# ============================================================================ #
#                 S k a f f o l d   f o r   K u b e r n e t e s
# ============================================================================ #

#.PHONY: *

run:  ## run skaffold
	skaffold run --label skaffold.dev/run-id="static"

dev:  ## run skaffold in dev mode
	skaffold dev --cleanup=false --label skaffold.dev/run-id="static"

delete:  ## delete skaffold
	skaffold delete
