#!/bin/bash

dir=$(
	cd "$(dirname "$0")" || exit
	pwd
)

"$dir/install/helm-plugins.bash"
