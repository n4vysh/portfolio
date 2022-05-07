#!/bin/bash

dir=$1

yaml="$dir/misc/precompiled-packages.yaml"
max=$(yq eval -N 'length' "$yaml")

for ((i = 0; i < "$max"; i++)); do
	url=$(yq eval ".[$i].url" "$yaml")
	file="${url##*/}"
	dest=$(yq eval ".[$i].dest" "$yaml")
	name=$(yq eval ".[$i].name" "$yaml")
	extract=$(yq eval ".[$i].extract" "$yaml")

	tmpdir="$(TMPDIR=/tmp/ mktemp -d)"
	cd "$tmpdir" || exit
	xh -F -o "$file" "$url"
	if [[ $extract == "true" ]]; then
		aunpack "$file" >/dev/null 2>&1
	fi
	if [[ $extract == "true" ]]; then
		install "$dest" "$dir/bin/$name"
	else
		install "$file" "$dir/bin/$name"
	fi
	# shellcheck disable=SC2064
	trap "rm -rf '$tmpdir'" EXIT
done
