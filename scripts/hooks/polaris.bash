#!/bin/bash

polaris audit \
	--helm-chart infra/charts/portfolio/ \
	--helm-values infra/charts/portfolio/ci/test-values.yaml \
	--format=pretty
