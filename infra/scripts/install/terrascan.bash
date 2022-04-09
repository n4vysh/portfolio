#!/bin/bash

version=1.13.2
prefix="terrascan_$version"

platform=''
case "$OSTYPE" in
darwin*) platform=Darwin ;;
linux*) platform=Linux ;;
win32) platform=Windows ;;
*)
	echo "Unsupported platform" >&2
	exit 1
	;;
esac

architecture=''
case "$(uname -m)" in
aarch64* | arm64) architecture=arm64 ;;
i686*) architecture=i386 ;;
x86_64*) architecture=x86_64 ;;
*)
	echo "Unsupported architecture" >&2
	exit 1
	;;
esac

file="${prefix}_${platform}_$architecture.tar.gz"
url="https://github.com/accurics/terrascan/releases/download/v$version/$file"

dest=$(
	cd "$(dirname "$0")/../../bin/" || exit
	pwd
)

tmpdir="$(TMPDIR=/tmp/ mktemp -d)"
cd "$tmpdir" || exit
xh -F -o "$file" "$url"
aunpack "$file" >/dev/null 2>&1
install "${prefix}_${platform}_$architecture/terrascan" "$dest/"
# shellcheck disable=SC2064
trap "rm -rf '$tmpdir'" EXIT
