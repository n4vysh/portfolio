#!/bin/bash

prefix=resvg

platform=''
case "$OSTYPE" in
darwin*) platform=macos-x86_64 ;;
linux*) platform=linux-x86_64 ;;
win32) platform=win64 ;;
*)
	echo "Unsupported platform" >&2
	exit 1
	;;
esac

ext=''
case "$OSTYPE" in
darwin*) ext=zip ;;
linux*) ext=tar.gz ;;
win32) ext=zip ;;
*)
	echo "Unsupported extension" >&2
	exit 1
	;;
esac

file="$prefix-$platform.$ext"
version=0.20.0
url="https://github.com/RazrFalcon/resvg/releases/download/v$version/$file"

dest=$(
	cd "$(dirname "$0")/../../bin/" || exit
	pwd
)

cd "$(TMPDIR=/tmp/ mktemp -d)" || exit
xh -F -o "$file" "$url"
aunpack "$file"
cp resvg "$dest"
