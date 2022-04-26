#!/bin/bash

dir=$(
	cd "$(dirname "$0")" || exit
	git rev-parse --show-toplevel
)
cd "$dir" || exit

"$dir/scripts/init/asdf-direnv.bash" "$dir/infra"
cat \
	<(
		awk '{print $1}' "$dir/infra/.tool-versions" |
			grep -v 'kubeval'
	) \
	<(
		cat <<-EOF
			kubeval https://github.com/stefansedich/asdf-kubeval
		EOF
	) |
	"$dir/scripts/install/asdf-packages.bash" "$dir/infra"

"$dir/scripts/execute-parallel.bash" direnv exec "$dir/infra" <<-EOF
	$dir/scripts/install/python-packages.bash $dir/infra
	$dir/scripts/install/precompiled-packages.bash $dir/infra
	$dir/infra/scripts/install/helm-plugins.bash
	$dir/infra/flux/scripts/download-crd-schemas.bash
EOF
