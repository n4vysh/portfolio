#!/bin/bash

dir=$(
	cd "$(dirname "$0")" || exit
	git rev-parse --show-toplevel
)
cd "$dir" || exit

"$dir/scripts/init/asdf-direnv.bash" "$dir/backend"
awk '{print $1}' "$dir/backend/.tool-versions" |
	"$dir/scripts/install/asdf-packages.bash" "$dir/backend"

"$dir/scripts/execute-parallel.bash" direnv exec "$dir/backend" <<-EOF
	$dir/backend/scripts/install/go-packages.bash
	$dir/scripts/install/precompiled-packages.bash $dir/backend
EOF
