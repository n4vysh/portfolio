#!/bin/bash

stern -n portfolio nginx -c nginx -o raw 2>/dev/null |
	ccze -A
