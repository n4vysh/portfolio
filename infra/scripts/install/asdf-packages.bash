#!/bin/bash

dir=$(
	cd "$(dirname "$0")" || exit
	pwd
)/../../
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

joblog="$(TMPDIR=/tmp/ mktemp)"
cat \
	<(
		awk '{print $1}' "$dir/.tool-versions" |
			grep -v 'kubeval'
	) \
	<(
		cat <<-EOF
			kubeval https://github.com/stefansedich/asdf-kubeval
		EOF
	) |
	sort |
	parallel -a - --colsep ' ' --joblog "$joblog" _install
cat "$joblog"
# shellcheck disable=SC2064
trap "rm -f '$joblog'" EXIT
