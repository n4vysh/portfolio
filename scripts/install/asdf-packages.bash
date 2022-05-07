#!/bin/bash

dir=$1
cd "$dir" || exit

_install() {
	package="$1"
	url="$2"
	if [[ $url == "" ]]; then
		asdf plugin add "$package"
	else
		asdf plugin add "$package" "$url"
	fi
	asdf install "$package"
}
export -f _install

root_dir=$(
	cd "$(dirname "$0")" || exit
	git rev-parse --show-toplevel
)

config="$dir/.tool-versions"
yaml="$dir/misc/unofficial-asdf-plugins.yaml"
if [[ -e $yaml ]]; then
	cat \
		<(
			(
				awk '{print $1}' "$config"
				yq eval '.[].name' "$yaml"
			) |
				sort |
				uniq -u
		) \
		<(
			yq eval '.[] | .name + " " + .url' "$yaml"
		) |
		sort |
		"$root_dir/scripts/execute-parallel.bash" _install
else
	awk '{print $1}' "$config" |
		sort |
		"$root_dir/scripts/execute-parallel.bash" _install
fi
