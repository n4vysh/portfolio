#!/bin/bash

dir=$(
	cd "$(dirname "$0")" || exit
	git rev-parse --show-toplevel
)

cd "$dir" || exit
awk '{print $1}' .tool-versions |
	xargs -t -I {} sh -c 'asdf install {} latest && asdf local {} latest'

cd "$dir/frontend/" || exit
awk '{print $1}' .tool-versions |
	xargs -t -I {} sh -c 'asdf install {} latest && asdf local {} latest'

cd "$dir/infra/" || exit
awk '{print $1}' .tool-versions |
	xargs -t -I {} sh -c 'asdf install {} latest && asdf local {} latest'
