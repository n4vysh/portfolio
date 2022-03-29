#!/bin/bash

name=portfolio

dir=$(
	cd "$(dirname "$0")" || exit
	git rev-parse --show-toplevel
)
ENV=$("$dir"/scripts/get-env.bash)

if [[ $ENV == development ]]; then
	kind export kubeconfig \
		--name "$name" \
		--kubeconfig "$HOME/.kube/configs/portfolio/$ENV/config.yaml"
elif [[ $ENV =~ ^(staging|production)$ ]]; then
	env=$(ENV="$ENV" "$dir"/scripts/get-env.bash --short 2>/dev/null)
	aws eks update-kubeconfig \
		--name "$env-$name" \
		--alias "$env-$name" \
		--kubeconfig "$HOME/.kube/configs/portfolio/$ENV/config.yaml"
else
	echo 'No support this environment' 1>&2
	exit 1
fi
