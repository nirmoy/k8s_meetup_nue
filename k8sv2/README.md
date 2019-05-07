# create a cluster

```
 kubeadm init --pod-network-cidr=10.244.0.0/16
```

# Apply cni
```
 kubectl apply -f  multus-with-flannel.yaml
 kubectl apply -f  crd.yaml
 kubectl apply -f  clusterrole.yaml
 kubectl apply -f  kubemacpool.yaml

```
