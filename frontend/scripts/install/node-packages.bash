#!/bin/bash

dir=$(
	cd "$(dirname "$0")" || exit
	pwd
)

(
	cd "$dir/../../misc/" || exit
	corepack enable pnpm
	corepack prepare --activate
	pnpm -v
	pnpm install
)
