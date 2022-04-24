#!/bin/bash

dir=$(
	cd "$(dirname "$0")" || exit
	pwd
)/../
cd "$dir" || exit

"$dir/scripts/init/asdf-direnv.bash"
"$dir/scripts/install/asdf-packages.bash"

joblog="$(TMPDIR=/tmp/ mktemp)"
parallel -a - --joblog "$joblog" direnv exec "$dir" <<EOF
$dir/scripts/install/python-packages.bash
$dir/scripts/install/precompiled-packages.bash
$dir/scripts/install/helm-plugins.bash
$dir/flux/scripts/download-crd-schemas.bash
EOF
cat "$joblog"
# shellcheck disable=SC2064
trap "rm -f '$joblog'" EXIT
