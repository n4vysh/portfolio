#!/bin/bash

name=portfolio

dir=$(
	cd "$(dirname "$0")" || exit
	git rev-parse --show-toplevel
)
ENV=$("$dir"/scripts/get-env.bash)

cd "$dir"/infra/ || exit
if [[ $ENV == development ]]; then
	mkdir -p kubectl/configs/"$ENV"/
	kind get kubeconfig --name "$name" >kubectl/configs/"$ENV"/config.yaml
elif [[ $ENV =~ ^(staging|production)$ ]]; then
	mkdir -p kubectl/configs/"$ENV"/
	terragrunt \
		output \
		--terragrunt-working-dir terraform/environments/"$ENV"/k8s \
		-raw \
		kubeconfig \
		2>/dev/null \
		>kubectl/configs/"$ENV"/config.yaml
else
	echo 'No support this environment' 1>&2
	exit 1
fi
