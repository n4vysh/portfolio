#!/bin/bash

version=0.9.19
prefix="infracost"

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

architecture=''
case "$(uname -m)" in
aarch64* | arm64) architecture=arm64 ;;
x86_64*) architecture=amd64 ;;
*)
	echo "Unsupported architecture" >&2
	exit 1
	;;
esac

file="$prefix-$platform-$architecture.tar.gz"
url="https://github.com/infracost/infracost/releases/download/v$version/$file"

dest=$(
	cd "$(dirname "$0")/../../bin/" || exit
	pwd
)

tmpdir="$(TMPDIR=/tmp/ mktemp -d)"
cd "$tmpdir" || exit
xh -F -o "$file" "$url"
aunpack "$file" >/dev/null 2>&1
cp "$prefix-$platform-$architecture" "$dest/$prefix"
# shellcheck disable=SC2064
trap "rm -rf '$tmpdir'" EXIT
