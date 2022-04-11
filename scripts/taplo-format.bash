#!/bin/bash

for f in "$@"; do
	[[ -e "$f" ]] || continue
	taplo format "$f"
done
