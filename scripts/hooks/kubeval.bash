#!/bin/bash

for name in portfolio target-group-bindings; do
	(
		set -x
		cd "infra/charts/$name" || exit
		helm template -f "ci/test-values.yaml" . |
			kubeval --ignore-missing-schemas
	)
	echo
done
