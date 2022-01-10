#!/bin/bash

if [[ ! $1 =~ ^(|--short)$ ]]; then
	echo "Unrecognized options: ${*}" 1>&2
	exit 1
fi

if [[ $ENV == common ]]; then
	echo "common"
elif [[ $ENV =~ ^dev(|elopment)$ ]]; then
	[[ $1 == '--short' ]] &&
		echo 'dev' ||
		echo "development"
elif [[ $ENV =~ ^st(g|age|aging)$ ]]; then
	[[ $1 == '--short' ]] &&
		echo 'stg' ||
		echo 'staging'
elif [[ $ENV =~ ^pr(d|od|oduction)$ ]]; then
	[[ $1 == '--short' ]] &&
		echo 'prd' ||
		echo 'production'
elif [[ ! -v ENV ]]; then
	# shellcheck disable=SC2016
	echo '$ENV not set' 1>&2
	exit 1
else
	echo "No such environment: $ENV" 1>&2
	exit 1
fi
