#!/bin/bash

version=8.5.1
prefix="gitleaks_$version"

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
armv7*) architecture=armv7 ;;
i686*) architecture=i386 ;;
x86) architecture=x32 ;;
x86_64*) architecture=x64 ;;
*)
	echo "Unsupported architecture" >&2
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

file="${prefix}_${platform}_$architecture.$ext"
url="https://github.com/zricethezav/gitleaks/releases/download/v$version/$file"

dest=$(
	cd "$(dirname "$0")/../../bin/" || exit
	pwd
)

cd "$(TMPDIR=/tmp/ mktemp -d)" || exit
xh -F -o "$file" "$url"
aunpack "$file"
install "${prefix}_${platform}_$architecture/gitleaks" "$dest/"
