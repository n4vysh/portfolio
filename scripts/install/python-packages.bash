#!/bin/bash

if ! type pipenv >/dev/null 2>&1; then
	pip install pipenv==v2022.1.8
fi
(
	cd misc/ || exit
	pipenv install
)
