#!/bin/bash

cat <<-'EOF'
	To check username and password of Grafana admin user, use following commands in another terminal window

	```bash
	kubectl -n kube-prometheus-stack get secret kube-prometheus-stack-grafana -o json |
	  jq '.data |
	  map_values(@base64d)'
	```

EOF

kubectl -n kube-prometheus-stack port-forward svc/kube-prometheus-stack-grafana 8080:80 &
sleep 2
xdg-open http://localhost:8080
wait
