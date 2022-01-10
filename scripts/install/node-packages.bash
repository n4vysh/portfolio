#!/bin/bash

(
	cd misc/ || exit
	corepack enable pnpm
	corepack prepare --activate
	pnpm -v
	pnpm install
)
