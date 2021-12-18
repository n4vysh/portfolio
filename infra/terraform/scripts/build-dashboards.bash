#!/bin/bash

id=fd91349
dir=tmp/kubernetes-monitoring/kubernetes-mixin

if [[ ! -d $dir ]]; then
  git clone git@github.com:kubernetes-monitoring/kubernetes-mixin.git "$dir"

  (
    cd "$dir" || exit
    git checkout -d "$id"
    jb install
    make dashboards_out
  )
fi

cp -v "$dir"/dashboards_out/* environments/common/grafana/dashboards/
