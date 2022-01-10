#!/bin/bash

version=0.2.5
prefix="kube-linter"

platform=''
case "$OSTYPE" in
darwin*) platform=darwin ;;
linux*) platform=linux ;;
win32) platform=windows ;;
*)
	echo "Unsupported platform" >&2
	exit 1
	;;
esac

file="$prefix-$platform.tar.gz"
url="https://github.com/stackrox/kube-linter/releases/download/$version/$file"

dest=$(
	cd "$(dirname "$0")/../../bin/" || exit
	pwd
)

cd "$(TMPDIR=/tmp/ mktemp -d)" || exit
xh -F -o "$file" "$url"
aunpack "$file"
cp "$prefix" "$dest/$prefix"
