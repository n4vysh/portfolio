#!/bin/bash

env=$1

if [[ $env == staging ]] || [[ $env == production ]]; then
  kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.6.1/cert-manager.crds.yaml
fi
