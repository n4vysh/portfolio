#!/bin/bash

declare -A flag
while getopts ie opt; do
	case "$opt" in
	i)
		flag[i]=1
		;;
	e)
		flag[e]=1
		;;
	*) ;;
	esac
done
shift $((OPTIND - 1))

dir=$(
	cd "$(dirname "$0")" || exit
	git rev-parse --show-toplevel
)

if [[ ${flag[i]} == 1 ]]; then
	"$dir/scripts/init/asdf-direnv-integration.bash"
fi

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
	"$dir/scripts/install/asdf-packages.bash" "$dir"
"$dir/scripts/init/asdf-direnv.bash" "$dir"
"$dir/scripts/init/asdf-direnv.bash" "$dir/frontend"
"$dir/scripts/init/asdf-direnv.bash" "$dir/backend"
"$dir/scripts/init/asdf-direnv.bash" "$dir/infra"

if [[ ${flag[e]} == 1 ]]; then
	eval "$(direnv export bash)"
fi

"$dir/scripts/execute-parallel.bash" direnv exec "$dir" <<-EOF
	$dir/scripts/install/python-packages.bash $dir
	$dir/scripts/install/node-packages.bash $dir
	$dir/scripts/install/precompiled-packages.bash $dir
	$dir/scripts/install/lefthook.bash
	$dir/frontend/scripts/install-packages.bash
	$dir/backend/scripts/install-packages.bash
	$dir/infra/scripts/install-packages.bash
	$dir/misc/scripts/download-vale-styles.bash
EOF
