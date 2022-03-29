#!/bin/bash

dir=$(
	cd "$(dirname "$0")" || exit
	git rev-parse --show-toplevel
)
ENV=$("$dir"/scripts/get-env.bash)

if [[ $ENV == development ]]; then
	just kind/create
	helm repo add bitnami https://charts.bitnami.com/bitnami
	helm repo update bitnami
	helm install contour \
		bitnami/contour \
		--namespace contour \
		--create-namespace \
		--version 7.0.7 \
		--set-string 'envoy.nodeSelector.ingress-ready=true' \
		--set 'envoy.tolerations[0].key=node-role.kubernetes.io/master' \
		--set 'envoy.tolerations[0].operator=Equal' \
		--set 'envoy.tolerations[0].effect=NoSchedule'
	(
		cd ../frontend || exit
		skaffold dev
	)
elif [[ $ENV =~ ^(staging|production)$ ]]; then
	just terragrunt/apply
	"$dir"/infra/scripts/get-creds.bash
else
	echo 'No support this environment' 1>&2
	exit 1
fi
