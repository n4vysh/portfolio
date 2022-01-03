#!/bin/bash

name=portfolio

dir=$(
	cd "$(dirname "$0")" || exit
	git rev-parse --show-toplevel
)
ENV=$("$dir"/scripts/get-env.bash)

if [[ $ENV == development ]]; then
	just infra/kind/create
	just infra/kubectl/get
	just infra/helmfile/apply
	just infra/helmfile/test
	kubens "$name"
	skaffold dev
elif [[ $ENV =~ ^(staging|production)$ ]]; then
	just infra/terraform/apply
	just infra/kubectl/get
	just infra/helmfile/apply
	just infra/helmfile/test
else
	echo 'No support this environment' 1>&2
	exit 1
fi
