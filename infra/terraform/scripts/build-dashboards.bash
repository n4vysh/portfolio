#!/bin/bash

(
  id=fd91349
  repo=kubernetes-monitoring/kubernetes-mixin
  dir=tmp/$repo

  if [[ ! -d $dir ]]; then
    git clone git@github.com:"$repo".git "$dir"

    (
      cd "$dir" || exit
      git checkout -d "$id"
      jb install
      make dashboards_out
    )
  fi

  cp -v "$dir"/dashboards_out/* environments/common/grafana/dashboards/
)

(
  id=8977eff
  repo=nginxinc/nginx-prometheus-exporter
  dir=tmp/$repo

  if [[ ! -d $dir ]]; then
    git clone git@github.com:"$repo".git "$dir"

    (
      cd "$dir" || exit
      git checkout -d "$id"
    )
  fi

  cp -v "$dir"/grafana/dashboard.json environments/common/grafana/dashboards/nginx.json
)
