#!/bin/bash

version=4.1.1
prefix="shellharden-$version"
case "$(uname -m)" in
x86_64*) suffix=x86_64-linux-gnu ;;
arm*) suffix=arm-linux-gnueabihf ;;
*)
	echo "Unsupported" >&2
	exit 1
	;;
esac
file="$prefix-$suffix"
url="https://github.com/anordal/shellharden/releases/download/v$version/$file"

dest=$(
	cd "$(dirname "$0")/../../bin/" || exit
	pwd
)

cd "$(TMPDIR=/tmp/ mktemp -d)" || exit
xh -F -o "$file" "$url"
install "$file" "$dest/shellharden"
