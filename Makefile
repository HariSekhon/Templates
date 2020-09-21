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


# this only works in GNU make and not in Mac's built-in make
#.ONESHELL:

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

.PHONY: test
test:
	@echo "running tests:"

.PHONY: tests
tests: test
	@:
