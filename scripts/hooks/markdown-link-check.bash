#!/bin/bash

for f in "$@"; do
	[[ -e "$f" ]] || continue
	just lint-md "$f"
done
