#!/bin/bash

version=1.14.0
prefix="kube-score_$version"

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
armv6*) architecture=armv6 ;;
x86_64*) architecture=amd64 ;;
*)
	echo "Unsupported architecture" >&2
	exit 1
	;;
esac

ext='tar.gz'

file="${prefix}_${platform}_$architecture.$ext"
url="https://github.com/zegl/kube-score/releases/download/v$version/$file"

dest=$(
	cd "$(dirname "$0")/../../bin/" || exit
	pwd
)

cd "$(TMPDIR=/tmp/ mktemp -d)" || exit
xh -F -o "$file" "$url"
aunpack "$file"
cp "${prefix}_${platform}_$architecture/kube-score" "$dest/kube-score"
