#!/bin/bash

dir=$(
	cd "$(dirname "$0")" || exit
	git rev-parse --show-toplevel
)
ENV=$("$dir"/scripts/get-env.bash)

cd "$dir"/infra/helmfile/ || exit
if [[ $ENV =~ ^(staging|production)$ ]]; then
	# Nginx
	echo 'Download Grafana Dashboard of Nginx'
	version=0.10.0
	repo=nginxinc/nginx-prometheus-exporter
	path=grafana/dashboard.json
	url=https://raw.githubusercontent.com/$repo/v$version/$path
	xh -F "$url" -o helmfiles/values/templates/dashboards/nginx.json

	# cert-manager
	echo 'Download Grafana Dashboard of cert-manager'
	rev=eae22f642aaa5d422e4766f6811df2158fc05539
	repo=uneeq-oss/cert-manager-mixin
	path=dashboards/cert-manager.json
	url=https://gitlab.com/$repo/-/raw/$rev/$path
	xh -F "$url" -o helmfiles/values/templates/dashboards/cert-manager.json
fi
