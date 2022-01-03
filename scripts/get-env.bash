#!/bin/bash

if [[ $ENV =~ ^dev(|elopment)$ ]]; then
	echo "development"
elif [[ $ENV =~ ^st(g|age|aging)$ ]]; then
	echo "staging"
elif [[ $ENV =~ ^pr(d|od|oduction)$ ]]; then
	echo "production"
elif [[ $ENV == common ]]; then
	echo "common"
else
	echo 'No such environment' 1>&2
	exit 1
fi
