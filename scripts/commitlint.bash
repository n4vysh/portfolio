#!/bin/bash

dir=$(
	cd "$(dirname "$0")" || exit
	git rev-parse --show-toplevel
)

if [[ -e "$dir/.git/COMMIT_EDITMSG" ]]; then
	commitlint --edit --verbose
else
	commitlint --from=HEAD^1 --verbose
fi
