This is the README file for episode 5 of Kubestronaut series.

Link to the video: https://www.youtube.com/watch?v=BsO4HxgvvE8

## Scenario 1: Create a deployment with (replicas=5, name=demo and image=nginx) then update the image with nginx:1.22.1

```
kubectl create deployment demo --replicas=5 --image=nginx
kubectl set image deployment/demo nginx=nginx:1.22.1
kubectl edit deployments.apps demo (and edit the image in image section)
```

## Scenario 2: Create a deployment with (name=demo, replicas=4 and image=nginx), and update the image to nginx:1.22.1 and then revert back to the first revision.

### Create deployment and update the image 

```
kubectl create deployment demo --replicas=4 --image=nginx
kubectl set image deployment/demo nginx=nginx:1.22.1 --record=true
```

### Check the history and rollback the deployment to revision 1

```
kubectl rollout history deployment
kubectl rollout undo deployment demo --to-revision=1 
```

### Annotate the change cause of deployment
```
kubectl annotate deployments/demo kubernetes.io/change-cause="Update the image to version 1.22.1"
kubectl rollout undo deployment demo --to-revision 1
```

## Scenario 3: Create a deployment and expose it as ClusterIP on port 80

### Create deployment and expose it
```
kubectl create deployment demo --image nginx
kubectl expose deployment demo --port 80
```

### Access the service

```
kubectl get service
curl `kubectl get -o template service/demo --template='{{.spec.clusterIP}}'`
```

## Scenario 4: Create a deployment and expose it as NodePort on port 80

### Create deployment and expose it

```
kubectl create deployment demo2 --image nginx
kubectl expose deployment demo2 --type NodePort --port 80
```

### Access the service

```
kubectl get service
curl `kubectl get node node01 -o jsonpath='{.status.addresses[?(@.type=="InternalIP")].address}'`:`kubectl get service demo2 -o jsonpath='{.spec.ports[0].nodePort}'`
```

## Scenario 5: Create a deployment and expose it as ClusterIP on port 3231

### Create deployment and expose it

```
kubectl create deployment demo3 --image nginx
kubectl expose deployment demo3 --type ClusterIP --port 3231 --target-port 80
```

### Access the service

```
curl `kubectl get service demo3 -o jsonpath='{.spec.clusterIP}'`:`kubectl get service demo3 -o jsonpath='{.spec.ports[0].port}'`
```