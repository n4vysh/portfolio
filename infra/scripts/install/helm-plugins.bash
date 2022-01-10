#!/bin/bash

dir=$(
	cd "$(dirname "$0")" || exit
	pwd
)

file="$dir/../../misc/helm-plugins.yaml"
max=$(yq eval '. | length' "$file")

for ((i = 0; i < max; i++)); do
	name=$(yq eval ".[$i].name" "$file")
	version=$(yq eval ".[$i].version" "$file")
	url=$(yq eval ".[$i].url" "$file")

	if [[ $version != "" ]]; then
		helm plugin list |
			grep "$name" >/dev/null ||
			helm plugin install "$url" --version "v$version"
	else
		helm plugin list |
			grep "$name" >/dev/null ||
			helm plugin install "$url"
	fi
done
