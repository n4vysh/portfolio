#!/bin/bash

dir=$(
	cd "$(dirname "$0")" || exit
	git rev-parse --show-toplevel
)
ENV=$("$dir"/scripts/get-env.bash)

if [[ $ENV == development ]]; then
	just infra/kind/delete
elif [[ $ENV =~ ^(staging|production)$ ]]; then
	just infra/terraform/destroy
else
	echo 'No support this environment' 1>&2
	exit 1
fi
