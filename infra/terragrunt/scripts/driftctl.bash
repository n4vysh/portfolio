#!/bin/bash

target=$1

dir=$(
	cd "$(dirname "$0")" || exit
	git rev-parse --show-toplevel
)
ENV=$("$dir"/scripts/get-env.bash)

cd "environments/$ENV/$target" || exit 1
if [[ $ENV == production ]]; then
	driftctl scan --from "tfstate+s3://prd-n4vysh-tfstate/$target/**/terraform.tfstate"
elif [[ $ENV == staging ]]; then
	echo 'skip'
else
	echo 'No support this environment' 1>&2
	exit 1
fi
