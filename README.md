# Example MetalLB setup for HomeLab k8s

*This is an L2 approach.*

## Install MetalLB

```bash
./install-metallb.sh

# verify
kubectl get all --namespace metallb-system
```

## Set address pool

```bash
# my network is set up to use 192.168.87.0/24
# DHCP is set to not assign below 192.168.87.20
kubectl apply --filename metallb-pool.yaml

# verify
kubectl --namespace metallb-system get IPAddressPool metallb-pool --output jsonpath='{.spec.addresses}' | jq
# ["192.168.87.2-192.168.87.19"]
```

## Set L2 Advertisement

```bash
kubectl apply --filename l2-advertisement.yaml 

# verify
kubectl --namespace metallb-system get L2Advertisement example -o jsonpath='{.spec.ipAddressPools}' | jq
# ["metallb-pool"]
```

## Install Demo App

```bash	
kubectl apply --filename test-it.yaml 

# verify external IP
kubectl --namespace mlb-test get services mlb-test-service

# see what happened
kubectl --namespace mlb-test describe services mlb-test-service

# Name:                     mlb-test-service
# Namespace:                mlb-test
# ...
# LoadBalancer Ingress:     192.168.87.2
# ...
# Events:
#  Type    Reason                Age                From                Message
#  ----    ------                ----               ----                -------
#  Normal  EnsuringLoadBalancer  19m                service-controller  Ensuring load balancer
#  Normal  AppliedDaemonSet      19m                service-controller  Applied LoadBalancer DaemonSet kube-system/svclb-mlb-test-service-3c43168b
#  Normal  IPAllocated           19m                metallb-controller  Assigned IP ["192.168.87.2"]
#  Normal  nodeAssigned          19m (x2 over 19m)  metallb-speaker     announcing from node "my-node" with protocol "layer2"
```

