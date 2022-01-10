#!/bin/bash

if [[ $ENV == production ]]; then
	driftctl scan --from 'tfstate+s3://prd-n4vysh-tfstate/**/terraform.tfstate'
elif [[ $ENV == staging ]]; then
	echo 'skip'
else
	echo 'No support this environment' 1>&2
	exit 1
fi
