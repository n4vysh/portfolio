#!/bin/bash

dir=$(
	cd "$(dirname "$0")" || exit
	git rev-parse --show-toplevel
)

cd "$dir/misc/vale-styles/" || exit

_download() {
	url="$1"
	file="${url##*/}"
	xh -F -o "$file" "$url" &&
		aunpack "$file" >/dev/null 2>&1 &&
		rm "$file"
}
export -f _download

"$dir/scripts/execute-parallel.bash" _download <<-EOF
	https://github.com/errata-ai/Google/releases/download/v0.3.3/Google.zip
	https://github.com/errata-ai/Joblint/releases/download/v0.4.1/Joblint.zip
	https://github.com/errata-ai/Microsoft/releases/download/v0.8.1/Microsoft.zip
	https://github.com/errata-ai/alex/releases/download/v0.1.1/alex.zip
	https://github.com/errata-ai/proselint/releases/download/v0.3.2/proselint.zip
	https://github.com/errata-ai/write-good/releases/download/v0.4.0/write-good.zip
EOF
