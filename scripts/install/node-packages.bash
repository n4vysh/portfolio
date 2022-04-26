#!/bin/bash

dir=$1

(
	cd "$dir/misc/" || exit
	corepack enable pnpm
	corepack prepare --activate
	asdf reshim nodejs
	pnpm -v
	pnpm install
)
