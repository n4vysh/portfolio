#!/bin/bash

env=$1
name=portfolio

if [[ $env == development ]]; then
  kind delete cluster --name "$name"
elif [[ $env == staging ]] || [[ $env == production ]]; then
  just terraform/destroy environments/"$env"
else
  echo 'No such environment'
fi
