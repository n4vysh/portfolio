#!/bin/bash

hooks=$(
	grep 'alias: ' .pre-commit-config.yaml |
		sort -u |
		sed 's/^.* alias: //' |
		jq -Rnc '[inputs]'
)
echo "::set-output name=hooks::$hooks"
