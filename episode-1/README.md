This is the README file for episode 1 of Kubestronaut series.

Link to the video: https://www.youtube.com/watch?v=FNbO99TVOrI&t=3281s

## Scenario 1: Run an application with an nginx image and pod name "your name".

```
kubectl run kubesimplify --image=nginx
kubectl get pods
kubectl get pods -owide
```
### Access the application.

```
curl `kubectl get pod kubesimplify -o jsonpath='{.status.podIP}'`
```

## List supported API resources.
```
kubectl api-resources
```

## Explain resources.
```
kubectl explain <resource name>
kubectl explain pod
```

## Create a single node k3s cluster.
```
curl -sfL https://get.k3s.io | sh - 
```
