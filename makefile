SHELL    := /usr/bin/env bash
SCRIPTS_DIR  = $(CURDIR)/scripts

.PHONY: help symlink cmdtool homebrew mac-setup brew pip npm emacs update

cmdtool:
	@source $(SCRIPTS_DIR)/cmd-line-tool.sh;

homebrew:
	@source $(SCRIPTS_DIR)/homebrew.sh;

shell: homebrew
	@source $(SCRIPTS_DIR)/shell.sh;

symlink:
	@source $(SCRIPTS_DIR)/symlink.sh;

mac-setup: cmdtool homebrew shell symlink
	@exec zsh;

brew: homebrew
	@source $(SCRIPTS_DIR)/brew.sh;

pip:
	@source $(SCRIPTS_DIR)/pip.sh;

pnpm:
	@source $(SCRIPTS_DIR)/pnpm.sh;

npm:
	@source $(SCRIPTS_DIR)/npm.sh;

update: brew pip npm
	@echo "Update brew, pip, pnpm...";

hist:
	@source $(SCRIPTS_DIR)/hist.sh;

emacs:
	@source $(SCRIPTS_DIR)/emacs.sh;

help::
	$(info make cmdtool      = check cmd-line-tool for MacOS)
	$(info make homebrew     = check homebrew for MacOS)
	$(info make shell        = check bash, zsh for MacOS)
	$(info make symlink      = create symlink according to links.conf)
	$(info make mac-setup    = check cmd-line-tool, homebrew and shell for MacOS)
	$(info make brew         = install or dump package according to Brewfile)
	$(info make pip          = install or freeze package according to requirements.txt)
	$(info make npm          = install or dump package according to Npmfile)
	$(info make update       = update brew, pip, npm package info)
	$(info make hist         = backup or restore zsh history)
	$(info make emacs        = bootstrap emacs)
	@true
