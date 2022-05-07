#!/bin/bash

kubectl -n kube-prometheus-stack port-forward svc/kube-prometheus-stack-grafana 8080:80 &
sleep 2
xdg-open http://localhost:8080
wait
