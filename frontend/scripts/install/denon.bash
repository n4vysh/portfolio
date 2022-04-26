#!/bin/bash

dir=$(
	cd "$(dirname "$0")" || exit
	git rev-parse --show-toplevel
)

cd "$dir/frontend/" || exit
deno install -qAf --unstable https://deno.land/x/denon@2.4.10/denon.ts
