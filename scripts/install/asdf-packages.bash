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
			grep -v 'kubeval' |
			grep -v 'linkerd' |
			grep -v 'vale'
	) \
	<(
		cat <<-EOF
			just https://github.com/heliumbrain/asdf-just
			kubeval https://github.com/stefansedich/asdf-kubeval
			linkerd https://github.com/KazW/asdf-linkerd.git
			vale https://github.com/osg/asdf-vale
		EOF
	) |
	sort |
	parallel -a - --colsep ' ' --joblog "$joblog" _install
cat "$joblog"
