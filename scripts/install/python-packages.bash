#!/bin/bash

dir=$1

if ! type pipenv >/dev/null 2>&1; then
	pip install pipenv==v2022.1.8
fi
(
	cd "$dir/misc/" || exit
	asdf reshim python
	pipenv install
)
