UNAME := $(shell uname)
ifeq ($(UNAME), Linux)
	include Makefile.Linux
endif

ifeq ($(UNAME), Darwin)
	include Makefile.macOS
endif

all: install

deploy:
	bash scripts/setup_dotfiles.sh

init:
	bash scripts/setup_vim.sh
	bash scripts/setup_tpm.sh

update:
	git pull origin main
	git submodule init
	git submodule update
	git submodule foreach git pull origin master

install: update deploy init
	@exec $$SHELL
