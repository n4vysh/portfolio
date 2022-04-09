#!/bin/bash

version=$(
	yq eval '.nodes[] | select(.role == "control-plane").image' ../kind/kind.yaml |
		sed 's|kindest/node:||'
)
helm template -f "portfolio/ci/test-values.yaml" portfolio/ |
	pluto detect --target-versions "k8s=$version" -
