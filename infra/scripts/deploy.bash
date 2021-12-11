#!/bin/bash

env=$1
name=portfolio
image=ghcr.io/n4vysh/portfolio

if [[ $env == development ]]; then
  kind load --name "$name" docker-image "$image"
  just helmfiles/deploy development
  kubens "$name"
  (cd .. && skaffold dev)
elif [[ $env == staging ]] || [[ $env == production ]]; then
  just helmfiles/deploy "$env"
  cmctl check api
else
  echo 'No such environment'
fi
