#!/bin/bash

dir=$(
	cd "$(dirname "$0")" || exit
	git rev-parse --show-toplevel
)
region=ap-northeast-1
for ENV in production staging; do
	export ENV
	env=$("$dir"/scripts/get-env.bash --short 2>/dev/null || true)

	bucket="$env-n4vysh-tfstate"
	table="$env-n4vysh-tfstate-lock"

	aws s3api create-bucket \
		--bucket "$bucket" \
		--create-bucket-configuration "LocationConstraint=$region" \
		--no-cli-pager
	aws s3api put-bucket-versioning \
		--bucket "$bucket" \
		--versioning-configuration Status=Enabled \
		--no-cli-pager
	aws dynamodb create-table \
		--table-name "$table" \
		--attribute-definitions AttributeName=LockID,AttributeType=S \
		--key-schema AttributeName=LockID,KeyType=HASH \
		--provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1 \
		--no-cli-pager
done
