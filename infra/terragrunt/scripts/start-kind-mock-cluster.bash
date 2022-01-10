#!/bin/bash

dir=$(
	cd "$(dirname "$0")" || exit
	git rev-parse --show-toplevel
)

kind get clusters |
	grep portfolio-mock >/dev/null ||
	just "$dir/infra/kind/create"
