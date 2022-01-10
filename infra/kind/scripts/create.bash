#!/bin/bash

name=portfolio

dir=$(
	cd "$(dirname "$0")" || exit
	git rev-parse --show-toplevel
)
ENV=$("$dir"/scripts/get-env.bash)

cd "$dir"/infra/kind/ || exit
if [[ $ENV == development ]]; then
	export KUBECONFIG="${KUBECONFIG:-$HOME/.kube/configs/portfolio/$ENV/config.yaml}"
	kind create cluster --name "$name" --config kind.yaml
elif [[ $ENV =~ ^(staging|production)$ ]]; then
	kind create cluster --name "$name-mock" --config kind.mock.yaml --kubeconfig /tmp/kubeconfig
else
	echo 'No support this environment' 1>&2
	exit 1
fi
