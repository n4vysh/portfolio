#!/bin/bash

joblog="$(TMPDIR=/tmp/ mktemp)"
cat - |
	parallel -a - --colsep ' ' --joblog "$joblog" "$@"
cat "$joblog"
# shellcheck disable=SC2064
trap "rm -f '$joblog'" EXIT
