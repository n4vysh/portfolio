#!/bin/bash

helm datree test \
	--ignore-missing-schemas \
	portfolio/ -- \
	--values portfolio/ci/test-values.yaml
