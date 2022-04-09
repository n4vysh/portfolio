#!/bin/bash

version=$(grep direnv .tool-versions | awk '{print $2}')

asdf plugin add direnv
asdf direnv setup --shell bash --version "$version"

mkdir -p ~/.config/direnv/
grep 'export DIRENV_LOG_FORMAT=""' ~/.config/direnv/direnvrc >/dev/null ||
	echo 'export DIRENV_LOG_FORMAT=""' >>~/.config/direnv/direnvrc

grep '[global]' ~/.config/direnv/direnv.toml >/dev/null ||
	echo '[global]' >>~/.config/direnv/direnv.toml
grep 'warn_timeout' ~/.config/direnv/direnv.toml >/dev/null ||
	echo 'warn_timeout = "10s"' >>~/.config/direnv/direnv.toml

eval "$(asdf exec direnv hook bash)"
