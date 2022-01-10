#!/bin/bash

environments=$(
	find \
		infra/terragrunt/environments/ \
		-maxdepth 1 \
		-mindepth 1 \
		-printf '%P\n' |
		jq -Rnc '[inputs]'
)
echo "::set-output name=environments::$environments"
