#!/bin/bash

name=portfolio

dir=$(
	cd "$(dirname "$0")" || exit
	git rev-parse --show-toplevel
)
ENV=$("$dir"/scripts/get-env.bash)

cd "$dir"/infra/kind/ || exit
if [[ $ENV == development ]]; then
	kind delete cluster --name "$name"
elif [[ $ENV =~ ^(staging|production|common)$ ]]; then
	echo 'No support this environment' 1>&2
	exit 1
fi
