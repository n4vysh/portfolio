#!/bin/bash

dir=$(
	cd "$(dirname "$0")" || exit
	pwd
)/../
cd "$dir" || exit

"$dir/scripts/init/asdf-direnv.bash"
"$dir/scripts/install/asdf-packages.bash"
"$dir/scripts/install/denon.bash"

joblog="$(TMPDIR=/tmp/ mktemp)"
parallel -a - --joblog "$joblog" direnv exec "$dir" <<EOF
$dir/scripts/install/aleph.bash
$dir/scripts/install/puppeteer.bash
$dir/scripts/install/node-packages.bash
$dir/scripts/install/oxipng.bash
$dir/scripts/install/resvg.bash
EOF
cat "$joblog"
# shellcheck disable=SC2064
trap "rm -f '$joblog'" EXIT
