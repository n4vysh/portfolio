#!/bin/bash

if type aws-vault >/dev/null 2>&1; then
	aws-vault list --profiles |
		grep "$AWS_PROFILE" >/dev/null ||
		aws-vault add "$AWS_PROFILE"
fi

just install
