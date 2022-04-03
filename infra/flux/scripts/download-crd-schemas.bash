#!/bin/bash

name=crd-schemas
ext=tar.gz
version=0.27.3
url="https://github.com/fluxcd/flux2/releases/download/v$version/$name.$ext"

dest=$(
	cd "$(dirname "$0")/../crd-schemas/" || exit
	pwd
)

cd "$(TMPDIR=/tmp/ mktemp -d)" || exit
xh -F -o "$name.$ext" "$url"
aunpack "$name.$ext"
cp "$name"/*.json "$dest/"
