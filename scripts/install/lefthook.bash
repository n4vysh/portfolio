#!/bin/bash

if type lefthook >/dev/null 2>&1; then
	# shellcheck disable=SC2016
	if ! grep 'if [ "$LEFTHOOK" = "0" ]; then' .git/hooks/pre-commit >/dev/null; then
		lefthook install
	fi

	# shellcheck disable=SC2016
	if ! grep 'if [ "$LEFTHOOK" = "0" ]; then' .git/hooks/commit-msg >/dev/null; then
		lefthook install
	fi
fi
