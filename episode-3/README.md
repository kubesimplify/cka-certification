This is the README file for episode 3 of Kubestronaut series. 

Link to the video: https://www.youtube.com/watch?v=rlU9SpsTw3Q&t=126s

## Scenario 1: Create a pod dummy on a node with label type=gpu

```
kubectl get node --show-labels

kubectl label node node01 type=gpu

kubectl run dummy --image=nginx --dry-run=client -oyaml > scenario1.yaml

vi scenario1.yaml

```
```
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: dummy
  name: dummy
spec:
  containers:
  - image: nginx
    name: dummy
    resources: {}
  nodeSelector: 
   type: gpu
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
```
```
kubectl apply -f scenario1.yaml
```
## Scenario 2: Assign a pod to node01, name = rockstar, image = nginx, do not use nodeSelector

```
kubectl run rockstar --image=nginx --dry-run=client -oyaml > scenario2.yaml

vi scenario2.yaml
```

```
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: rockstar
  name: rockstar
spec:
  nodeName: node01
  containers:
  - image: nginx
    name: rockstar
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
```
```
kubectl apply -f scenario2.yaml
```

## Scenario 3: Create two pods image=nginx, name=nginx and name=demo, image=redis, they should comeup on the same node and you cannot use nodeSelector or nodeName.

```
kubectl run nginx --image=nginx --labels run=cka --dry-run=client -oyaml > scenario3-nginx.yaml
kubectl run demo --image=redis  --dry-run=client -oyaml > scenario3-redis.yaml
```

```
vi scenario3-redis.yaml
```
```
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: demo
  name: demo
spec:
  affinity:
    podAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
      - labelSelector:
          matchExpressions:
          - key: run
            operator: In
            values:
            - cka
        topologyKey: kubernetes.io/hostname
  containers:
  - image: redis
    name: demo
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
```
```
kubectl apply -f scenario3-nginx.yaml
kubectl apply -f scenario3-redis.yaml
```

## Scenario 4: Create a deployment with 2 replicas and both should be on different nodes

```
kubectl create deployment nginx --image nginx --replicas 2 --dry-run=client -oyaml > scenario4.yaml
vi scenario4.yaml
```
```
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: nginx
  name: nginx
spec:

  replicas: 2
  selector:
    matchLabels:
      app: nginx
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: nginx
    spec:
      containers:
      - image: nginx
        name: nginx
        resources: {}
      affinity:
        podAntiAffinity:
            requiredDuringSchedulingIgnoredDuringExecution:
              - labelSelector:
                  matchLabels:
                    app: nginx
              # - weight: 100
              # podAffinityTerm:
              #   labelSelector:
              #     matchExpressions:
              #     - key: app
              #       operator: In
              #       values:
              #       - nginx
                topologyKey: kubernetes.io/hostname
status: {}
```
```
kubectl apply -f scenario4.yaml
kubectl get pods -owide
```