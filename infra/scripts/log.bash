#!/bin/bash

stern -n portfolio gin -o raw 2>/dev/null |
	jq -r .
