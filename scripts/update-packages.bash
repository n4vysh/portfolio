#!/bin/bash

awk '{print $1}' .tool-versions |
	xargs -t -I {} sh -c 'asdf install {} latest && asdf local {} latest'
