#!/bin/bash

# create temporary yaml file to check kubernetes manifest with pipeline
# NOTE: checkov ignore file without extension
yaml=$(TMPDIR=/tmp mktemp --dry-run --suffix=.yaml)
ln -s /dev/stdin "$yaml"
# shellcheck disable=SC2064
trap "rm '$yaml'" EXIT

set -e
name=portfolio

(
	set -x
	cd "$name" || exit
	helm template -f "ci/test-values.yaml" . |
		checkov \
			--quiet \
			-f "$yaml" \
			--framework kubernetes \
			--compact
)
