#!/bin/bash

polaris audit \
	--helm-chart portfolio/ \
	--helm-values portfolio/ci/test-values.yaml \
	--format=pretty
