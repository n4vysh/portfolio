#!/bin/bash

if [[ $CI == true ]]; then
	mkdir -p \
		dist/ \
		dist/404 \
		dist/_aleph \
		dist/_aleph/pages \
		dist/images \
		dist/keys
	touch dist/{,404/,_aleph/{,pages/},images/,keys/}dummy
	touch dist/{,404/}index.html
	touch dist/robots.txt
fi
