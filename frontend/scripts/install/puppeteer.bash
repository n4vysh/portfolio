#!/bin/bash

dir=$(
	cd "$(dirname "$0")" || exit
	git rev-parse --show-toplevel
)

cd "$dir/frontend/" || exit
[[ -d ~/.cache/deno/deno_puppeteer/chromium/ ]] ||
	denon install:puppeteer
