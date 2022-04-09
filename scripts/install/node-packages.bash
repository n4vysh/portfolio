#!/bin/bash

(
	cd misc/ || exit
	corepack enable pnpm
	corepack prepare --activate
	asdf reshim nodejs
	pnpm -v
	pnpm install
)
