#!/bin/bash

env="$1"

dirs=$(
	find \
		"infra/terragrunt/environments/$env" \
		-maxdepth 1 \
		-mindepth 1 \
		-type d \
		-printf '%P\n' |
		jq -Rnc '[inputs]'
)
echo "::set-output name=dirs::$dirs"
