#!/bin/bash

dir=$(
	cd "$(dirname "$0")" || exit
	git rev-parse --show-toplevel
)
ENV=$("$dir"/scripts/get-env.bash)

if [[ $ENV == development ]]; then
	just kind/create
	export KUBECONFIG="${KUBECONFIG:-$HOME/.kube/configs/portfolio/$ENV/config.yaml}"
	istioctl install -f misc/istio-operator.yaml
	(
		cd "$dir/backend" || exit
		skaffold dev
	)
elif [[ $ENV =~ ^(staging|production)$ ]]; then
	just terragrunt/apply
	"$dir"/infra/scripts/get-creds.bash
else
	echo 'No support this environment' 1>&2
	exit 1
fi
