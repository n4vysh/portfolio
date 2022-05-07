#!/bin/bash

dir=$(
	cd "$(dirname "$0")" || exit
	git rev-parse --show-toplevel
)
cd "$dir" || exit

"$dir/scripts/init/asdf-direnv.bash" "$dir/frontend"
"$dir/scripts/install/asdf-packages.bash" "$dir/frontend"
"$dir/frontend/scripts/install/denon.bash"

"$dir/scripts/execute-parallel.bash" direnv exec "$dir/frontend" <<-EOF
	$dir/frontend/scripts/install/aleph.bash
	$dir/frontend/scripts/install/puppeteer.bash
	$dir/scripts/install/node-packages.bash $dir/frontend
	$dir/scripts/install/precompiled-packages.bash $dir/frontend
EOF
