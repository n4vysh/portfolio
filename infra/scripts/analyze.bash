#!/bin/bash

stern -n portfolio nginx -c nginx -o raw 2>/dev/null |
	goaccess -p misc/goaccess.conf -
