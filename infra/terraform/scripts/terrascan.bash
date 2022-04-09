#!/bin/bash

find modules/ -mindepth 1 -maxdepth 1 -type d -print0 |
	xargs -0 -t -I {} terrascan scan -d {} -i terraform -v
