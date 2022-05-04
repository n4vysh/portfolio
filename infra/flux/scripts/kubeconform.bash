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
	-skip 'Gateway,PodMonitor,ServiceMonitor,Canary'
)

(
	set -x
	kubeconform "${opts[@]}" "./clusters/production/"*.yaml
)

mapfile -t dirs < <(find kustomize/ -mindepth 1 -maxdepth 1 -type d)
for dir in "${dirs[@]}"; do
	(
		# use kustomize-controller build options
		set -x
		kubectl kustomize \
			--load-restrictor=LoadRestrictionsNone \
			--reorder=legacy \
			"./$dir/overlays/production/" |
			kubeconform "${opts[@]}"
	)
done
