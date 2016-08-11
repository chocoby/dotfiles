UNAME := $(shell uname)
ifeq ($(UNAME), Linux)
	include Makefile.Linux
endif

all: install

deploy:
	bash scripts/setup_dotfiles.sh

init:

update:
	git pull origin master
	git submodule init
	git submodule update
	git submodule foreach git pull origin master

install: update deploy init
	@exec $$SHELL
