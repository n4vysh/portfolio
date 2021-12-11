#!/bin/bash

env=$1
name=portfolio

if [[ $env == development ]]; then
  kind create cluster --name "$name" --config ./kind.yaml
elif [[ $env == staging ]] || [[ $env == production ]]; then
  just terraform/apply environments/"$env"

  (
    set -x
    if [[ -v CIVO_API_KEY ]]; then
      civo apikey current localhost ||
        civo apikey save localhost --load-from-env
    fi
    mkdir -p ./kubeconfigs/"$env"
    export KUBECONFIG=./kubeconfigs/"$env"/config.yaml
    civo kubernetes config "portfolio-$env" --save --overwrite -p "$KUBECONFIG"
  )
else
  echo 'No such environment'
fi
