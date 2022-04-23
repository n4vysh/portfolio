#!/bin/bash

dir=$(
	cd "$(dirname "$0")/../" || exit
	pwd
)
cd "$dir" || exit

opts=(
	-schema-location default
	-schema-location "./crd-schemas/{{ .ResourceKind }}{{ .KindSuffix }}.json"
	-verbose
	-strict
	-skip Gateway
)

set -x
kubeconform "${opts[@]}" "./clusters/production/"*.yaml
# use kustomize-controller build options
kubectl kustomize \
	--load-restrictor=LoadRestrictionsNone \
	--reorder=legacy \
	"./infra/overlays/production/" |
	kubeconform "${opts[@]}"
# need crd schemas of prometheus-operator, istio, and flagger
# kubectl kustomize apps/overlays/production/ | kubeconform "${opts[@]}"
