#!/bin/bash

version=$(
	yq eval '.nodes[] | select(.role == "control-plane").image' infra/kind/kind.yaml |
		sed 's|kindest/node:||'
)
helm template -f "infra/charts/portfolio/ci/test-values.yaml" infra/charts/portfolio/ |
	pluto detect --target-versions "k8s=$version" -
