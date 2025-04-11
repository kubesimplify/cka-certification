Create a persistent volume claim 'kubesimplify'
Access mode: RWO
Capacity : 2Gi
Storageclass: local-path
Use that pvc in a new pod `thekube`
 with nginx image  and volume mounted at `/usr/share/nginx/html/index.html`

 ```
kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/v0.0.24/deploy/local-path-storage.yaml
kubectl patch storageclass local-path -p '{"metadata":{"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
 ```
 ```
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: saiyam
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 2Gi
 ```

 ```
kind: Pod
metadata:
  name: ksctl
spec:
  volumes:
    - name: pv-saiyam
      persistentVolumeClaim:
        claimName: saiyam
  containers:
    - name: ksctl
      image: nginx
      ports:
        - containerPort: 80
          name: "http"
      volumeMounts:
        - mountPath: "/usr/share/nginx/html"
          name: pv-saiyam
 ```

---
Create a single Pod with:

- 3 containers sharing /var/log via emptyDir volume.
- c1 and c2 write a file (/var/log/newfile).
- c3 reads and displays the content using cat /var/log/newfile.
The pod must not crash after these commands are executed.

Solution:
emptyDir is a temporary shared volume:
It is created when a Pod is assigned to a node.
It exists as long as the Pod is running.
All containers in the Pod can read/write to it.
Perfect for sharing data between containers (e.g., logs, configs, temp files).

```
apiVersion: v1
kind: Pod
metadata:
  name: multi-container-pod
spec:
  volumes:
    - name: shared-logs
      emptyDir: {} 
  restartPolicy: OnFailure
  containers:
    - name: c1
      image: busybox
      command: ["/bin/sh", "-c"]
      args:
        - echo "Hello from c1 container." > /var/log/newfile
      volumeMounts:
        - name: shared-logs
          mountPath: /var/log

    - name: c2
      image: busybox
      command: ["/bin/sh", "-c"]
      args:
        - echo "Hello from c2 container." >> /var/log/newfile
      volumeMounts:
        - name: shared-logs
          mountPath: /var/log

    - name: c3
      image: busybox
      command: ["/bin/sh", "-c"]
      args:
        - sleep 10; cat /var/log/newfile
      volumeMounts:
        - name: shared-logs
          mountPath: /var/log

```

---

Scenario 3 -> CRI- dockerd

Q - Prepare the system for Kubernetes by setting up cri-dockerd as the container runtime interface.

- Install the cri-dockerd Debian package
- Start the cri-dockerd service
- Enable and start the cri-dockerd systemd service
- Verify that the service is running
- Configure the following system networking parameters:
```
net.bridge.bridge-nf-call-iptables = 1
net.ipv6.conf.all.forwarding = 1
net.ipv4.ip_forward = 1
```

- Download and Install cri-dockerd (if not already present)
```
wget https://github.com/Mirantis/cri-dockerd/releases/download/v0.3.9/cri-dockerd_0.3.9.3-0.ubuntu-focal_amd64.deb
sudo dpkg -i cri-dockerd_0.3.9.3-0.ubuntu-focal_amd64.deb
```
-  Start and Enable cri-dockerd
```
sudo systemctl start cri-docker.service
sudo systemctl enable cri-docker.service
```

sudo modprobe br_netfilter

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables = 1
net.ipv6.conf.all.forwarding = 1
net.ipv4.ip_forward = 1
EOF

sudo sysctl --system
