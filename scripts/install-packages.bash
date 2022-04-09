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

"$dir/scripts/install/asdf-packages.bash"
"$dir/scripts/init/asdf-direnv.bash"
"$dir/frontend/scripts/init/asdf-direnv.bash"

if [[ ${flag[e]} == 1 ]]; then
	eval "$(direnv export bash)"
fi

joblog="$(TMPDIR=/tmp/ mktemp)"
parallel -a - --joblog "$joblog" direnv exec "$dir" <<EOF
$dir/scripts/install/python-packages.bash
$dir/scripts/install/node-packages.bash
$dir/scripts/install/lefthook.bash
$dir/scripts/install/shellharden.bash
$dir/scripts/install/actionlint.bash
$dir/scripts/install/gitleaks.bash
$dir/frontend/scripts/install-packages.bash
$dir/infra/scripts/install-packages.bash
$dir/misc/scripts/download-vale-styles.bash
EOF
cat "$joblog"
# shellcheck disable=SC2064
trap "rm -f '$joblog'" EXIT
