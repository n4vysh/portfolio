#!/bin/bash

dir=$(
	cd "$(dirname "$0")" || exit
	git rev-parse --show-toplevel
)
ENV=$("$dir"/scripts/get-env.bash)

if [[ $ENV =~ ^(staging|production)$ ]]; then
	kubectl -n kube-prometheus-stack port-forward svc/kube-prometheus-stack-grafana 8080:80
else
	echo 'No support this environment' 1>&2
	exit 1
fi
