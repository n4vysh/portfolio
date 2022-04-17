#!/bin/bash

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

joblog="$(TMPDIR=/tmp/ mktemp)"
awk '{print $1}' ".tool-versions" |
	sort |
	parallel -a - --colsep ' ' --joblog "$joblog" _install
cat "$joblog"
# shellcheck disable=SC2064
trap "rm -f '$joblog'" EXIT
