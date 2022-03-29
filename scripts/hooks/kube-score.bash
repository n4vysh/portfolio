#!/bin/bash

helm template \
	-f infra/charts/portfolio/ci/test-values.yaml \
	infra/charts/portfolio/ |
	kube-score score -v -
