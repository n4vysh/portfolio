#!/bin/bash

helm template \
	-f portfolio/ci/test-values.yaml \
	portfolio/ |
	kube-score score -v -
