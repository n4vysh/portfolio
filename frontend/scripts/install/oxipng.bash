#!/bin/bash

version=5.0.1
prefix="oxipng-$version-x86_64"

platform=''
case "$OSTYPE" in
darwin*) platform=apple-darwin ;;
linux*) platform=unknown-linux-musl ;;
win32) platform=pc-windows-msvc ;;
*)
	echo "Unsupported platform" >&2
	exit 1
	;;
esac

ext=''
case "$OSTYPE" in
darwin*) ext=tar.gz ;;
linux*) ext=tar.gz ;;
win32) ext=zip ;;
*)
	echo "Unsupported extension" >&2
	exit 1
	;;
esac

file="$prefix-$platform.$ext"
url="https://github.com/shssoichiro/oxipng/releases/download/v$version/$file"

dest=$(
	cd "$(dirname "$0")/../../bin/" || exit
	pwd
)

cd "$(TMPDIR=/tmp/ mktemp -d)" || exit
xh -F -o "$file" "$url"
aunpack "$file"
cp oxipng-*/oxipng "$dest"
