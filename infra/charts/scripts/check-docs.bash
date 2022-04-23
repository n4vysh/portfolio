#!/bin/bash

diff -u <(helm-docs -d -l panic) <(cat ./*/README.md)
