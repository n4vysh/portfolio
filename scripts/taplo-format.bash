#!/bin/bash

for f in "$@"; do
	[[ -e "$f" ]] || continue
	just fmt-toml "$f"
done
