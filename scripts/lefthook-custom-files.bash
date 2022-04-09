#!/bin/bash

if [[ -n $(git diff --name-only --cached) ]]; then
	git diff --name-only --cached
elif [[ -n $(git ls-files -m) ]]; then
	git ls-files -m
else
	git diff --name-only HEAD^1
fi
