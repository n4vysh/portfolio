include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules//grafana"
}

inputs = {
  dashboards = formatlist(
    "dashboards/%s",
    [
      "apiserver.json",
      "cluster-total.json",
      "controller-manager.json",
      "k8s-resources-cluster.json",
      "k8s-resources-namespace.json",
      "k8s-resources-node.json",
      "k8s-resources-pod.json",
      "k8s-resources-workload.json",
      "k8s-resources-workloads-namespace.json",
      "kubelet.json",
      "namespace-by-pod.json",
      "namespace-by-workload.json",
      "persistentvolumesusage.json",
      "pod-total.json",
      "proxy.json",
      "scheduler.json",
      "workload-total.json",
    ]
  )
}
