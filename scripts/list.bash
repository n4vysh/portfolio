#!/bin/bash

find . -name justfile |
	sed 's/justfile//' |
	sort |
	xargs -t -I {} just --list {}
