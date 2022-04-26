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
cat - |
	sort |
	"$root_dir/scripts/execute-parallel.bash" _install
