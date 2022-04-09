#!/bin/bash

find modules/ -mindepth 1 -maxdepth 1 |
	while IFS= read -r dir; do
		(
			cd "$dir" || exit
			# https://github.com/hashicorp/terraform/issues/28490
			grep -r aws.secondary versions.tf >/dev/null &&
				echo 'provider "aws" { alias = "secondary" }' >provider.tf
			terraform init -backend=false >/dev/null
			echo "$dir"
			terraform validate
			grep -r aws.secondary versions.tf >/dev/null &&
				rm provider.tf
			rm -r .terraform*
		)
	done
