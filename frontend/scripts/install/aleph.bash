#!/bin/bash

dir=$(
	cd "$(dirname "$0")" || exit
	git rev-parse --show-toplevel
)

cd "$dir/frontend/" || exit
type aleph >/dev/null 2>&1 ||
	denon install:aleph
