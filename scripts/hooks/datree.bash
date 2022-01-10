#!/bin/bash

helm datree test \
	--ignore-missing-schemas \
	infra/charts/portfolio/ -- \
	--values infra/charts/portfolio/ci/test-values.yaml
