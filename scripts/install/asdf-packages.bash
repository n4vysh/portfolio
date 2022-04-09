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
cat \
	<(
		awk '{print $1}' .tool-versions |
			grep -v 'just' |
			grep -v 'vale' |
			grep -v 'lefthook'
	) \
	<(
		cat <<-EOF
			just https://github.com/heliumbrain/asdf-just
			vale https://github.com/osg/asdf-vale
			lefthook https://gitlab.com/jtzero/asdf-lefthook.git
		EOF
	) |
	sort |
	parallel -a - --colsep ' ' --joblog "$joblog" _install
cat "$joblog"
# shellcheck disable=SC2064
trap "rm -f '$joblog'" EXIT
