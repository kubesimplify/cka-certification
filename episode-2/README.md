This is the README file for episode 2 of Kubestronaut series.

Link to the video: https://www.youtube.com/watch?v=yEcjP2Rq9-I&t=2s

## Add commands for pod
```
kubectl run nginx --image=nginx
```

## Add commands for dryrun for pods
```
kubectl run nginx --image=nginx --dry-run=client -oyaml
```
## Scenario 1: Create a multi container pod
```
vi multiContainer.yaml
```
```
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: multicontainer
  name: multicontainer
spec:
  initContainers:
  - image: busybox
    name: busybox
    resources: {}
    restartPolicy: Always
    command: ["sleep", "100"]
  containers:
  - image: nginx
    name: nginx
    resources: {}

  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
```
```
kubectl apply -f multiContainer.yaml
```

## Scenario 2: Create a pod with name kubesimplify image nginx and add initContainer name friday-init, /usr/share/nginx/html "Hello World"

```
kubectl run kubesimplify --image nginx --dry-run=client -oyaml > initContainer.yaml
vi initContainer.yaml
```
```
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: kubesimplify
  name: kubesimplify
spec:
  initContainers:
  - name: friday-init
    image: busybox
    command: ['sh', '-c', 'echo "Hello world!" | tee tmp/index.html']
    volumeMounts:
    - name:  demo
      mountPath: "/tmp/"
  containers:
  - image: nginx
    name: kubesimplify
    resources: {}
    volumeMounts:
    - name: demo
      mountPath: /usr/share/nginx/html
  volumes:
  - name: demo
    emptyDir: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
```
```
kubectl apply -f initContainer.yaml
```
### Exec into pod and curl the container.
```
kubectl exec -it pods/kubesimplify -- curl localhost
```