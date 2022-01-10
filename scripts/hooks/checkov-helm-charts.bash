#!/bin/bash

# create temporary yaml file to check kubernetes manifest with pipeline
# NOTE: checkov ignore file without extension
yaml=$(TMPDIR=/tmp mktemp --dry-run --suffix=.yaml)
ln -s /dev/stdin "$yaml"
# shellcheck disable=SC2064
trap "rm '$yaml'" EXIT

for name in portfolio target-group-bindings; do
	(
		set -x
		cd "infra/charts/$name" || exit
		helm template -f "ci/test-values.yaml" . |
			pipenv run checkov \
				--quiet \
				-f "$yaml" \
				--framework kubernetes \
				--compact
	)
done
