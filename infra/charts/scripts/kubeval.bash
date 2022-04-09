#!/bin/bash

name=portfolio
(
	set -x
	cd "$name" || exit
	helm template -f "ci/test-values.yaml" . |
		kubeval --ignore-missing-schemas
)
echo
