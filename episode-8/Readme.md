### Storage PVC retain
A deployment running a MySQL database was accidentally deleted from the kubesimplify  namespace.You need to bring the MySQL deployment back online using the existing PersistentVolume that was previously bound.

What to do?
- A PersistentVolume already exists in the cluster and is available for reuse.
- Create a PersistentVolumeClaim named mysql-pvc in the kubesimplify namespace.
Access mode: ReadWriteOnce
Storage: 250Mi
- Edit the deployment file to use the PVC.

Apply the updated deployment.

Ensure the MySQL deployment is up and running with the reused persistent volume.



### Priority class
A new application deployment kubesimplify-api in the priority-zone namespace must be guaranteed to run even under resource pressure.

You are tasked with the following:

Task:
- Identify the highest user-defined PriorityClass in the cluster.
- Create a new PriorityClass named critical-priority with a value 1 less than the highest existing user-defined priority class.
- Patch the kubesimplify-api Deployment in the priority-zone namespace to use the critical-priority class.
- Confirm that the rollout completes successfully.
- It is expected that other lower-priority pods in the same namespace may be evicted to make room.
- Do not alter other deployments or priority classes in the namespace.

Setup:
```
kubectl create ns priority-zone
## get high priority class
kubectl get priorityclass.scheduling.k8s.io -o jsonpath="{range .items[*]}{.metadata.name}:{.value}{'\n'}{end}" | sort -t: -k2 -n
## deployment patch
kubectl patch deployment kubesimplify-api -n priority-zone --type='json' -p='[{"op": "add", "path": "/spec/template/spec/priorityClassName", "value": "critical-priority"}]'
kubectl rollout status deployment/kubesimplify-api -n priority-zone
kubectl get pods -n priority-zone -o wide

```