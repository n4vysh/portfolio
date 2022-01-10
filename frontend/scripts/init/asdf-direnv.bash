#!/bin/bash

dir=$(
	cd "$(dirname "$0")" || exit
	git rev-parse --show-toplevel
)

cd "$dir/frontend" || exit
if type asdf >/dev/null 2>&1 &&
	asdf which direnv >/dev/null 2>&1 &&
	asdf exec direnv status |
	grep 'Found RC allowed false' >/dev/null; then
	asdf exec direnv allow
fi
