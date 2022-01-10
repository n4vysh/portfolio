#!/bin/bash

dir=$(
	cd "$(dirname "$0")" || exit
	pwd
)

"$dir/install/denon.bash"
"$dir/install/aleph.bash"
"$dir/install/puppeteer.bash"
"$dir/install/node-packages.bash"
"$dir/install/oxipng.bash"
"$dir/install/resvg.bash"
