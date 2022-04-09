#!/bin/bash

name=crd-schemas
ext=tar.gz
version=0.27.3
url="https://github.com/fluxcd/flux2/releases/download/v$version/$name.$ext"

dest=$(
	cd "$(dirname "$0")/../crd-schemas/" || exit
	pwd
)

tmpdir="$(TMPDIR=/tmp/ mktemp -d)"
cd "$tmpdir" || exit
xh -F -o "$name.$ext" "$url"
aunpack "$name.$ext" >/dev/null 2>&1
cp "$name"/*.json "$dest/"
# shellcheck disable=SC2064
trap "rm -rf '$tmpdir'" EXIT
