#!/bin/bash

version=1.6.8
prefix="actionlint_$version"

platform=''
case "$OSTYPE" in
darwin*) platform=darwin ;;
FreeBSD*) platform=freebsd ;;
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
armv6*) architecture=armv6 ;;
i686*) architecture=386 ;;
x86_64*) architecture=amd64 ;;
*)
	echo "Unsupported architecture" >&2
	exit 1
	;;
esac

ext=''
case "$OSTYPE" in
darwin*) ext=tar.gz ;;
FreeBSD*) ext=tar.gz ;;
linux*) ext=tar.gz ;;
win32) ext=zip ;;
*)
	echo "Unsupported extension" >&2
	exit 1
	;;
esac

file="${prefix}_${platform}_$architecture.$ext"
url="https://github.com/rhysd/actionlint/releases/download/v$version/$file"

dest=$(
	cd "$(dirname "$0")/../../bin/" || exit
	pwd
)

tmpdir="$(TMPDIR=/tmp/ mktemp -d)"
cd "$tmpdir" || exit
xh -F -o "$file" "$url"
aunpack "$file" >/dev/null 2>&1
cp actionlint_*/actionlint "$dest/actionlint"
# shellcheck disable=SC2064
trap "rm -rf '$tmpdir'" EXIT
