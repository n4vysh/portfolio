#!/bin/bash

env=$1

if [[ $env == development ]] ||
  [[ $env == staging ]] ||
  [[ $env == production ]]; then
  just helmfiles/diff "$env"
else
  echo 'No such environment'
fi
