This is the README file for episode 4 of Kubestronaut series.

Link to the video: https://www.youtube.com/watch?v=mTbx8jOJ5L0&t=907s

Link to the gist: https://gist.githubusercontent.com/saiyam1814/bb16f1ad8505e83342dd04370183ed4e/raw/1c1e1d97fc18d5c3afa5686024adca82e365b6a4/kubernetes132.sh

curl https://gist.githubusercontent.com/saiyam1814/bb16f1ad8505e83342dd04370183ed4e/raw/1c1e1d97fc18d5c3afa5686024adca82e365b6a4/kubernetes132.sh > install.sh

## Bootstrapping Kubernetes cluster with kubeadm
```
sh install.sh
```

## Upgrade kubernetes cluster from 1.32.1 to 1.32.2

curl https://gist.githubusercontent.com/saiyam1814/2064faf4ffe9d5cd1b0421709dee35c0/raw/c2d77d1eb6740e9221726d65617a6882a6b1b0d3/gistfile1.txt > upgrade.sh

### Steps to upgrade controlplane.


### Installing kubeadm

```
sudo apt-mark unhold kubeadm && \
sudo apt-get update && sudo apt-get install -y kubeadm='1.32.2-*' && \
sudo apt-mark hold kubeadm
```

### Apply the kubeadm upgrade

```
sudo kubeadm upgrade apply v1.32.2
```

### Drain the controlplane

```
kubectl drain cplane-01 --ignore-daemonsets
```

### Install new versions of kubelet and kubectl 

```
sudo apt-mark unhold kubelet kubectl && \
sudo apt-get update && sudo apt-get install -y kubelet='1.32.2-*' kubectl='1.32.2-*' && \
sudo apt-mark hold kubelet kubectl
```

### Restart the kubelet

```
sudo systemctl daemon-reload
sudo systemctl restart kubelet
```

### Uncordon the  controlplane
```
kubectl uncordon cplane-01
```

### Steps to upgrade node

#### SSH to the node

```
ssh node01
```
### Upgrade node

```
sudo kubeadm upgrade node
```

### Install new versions of kubelet and kubectl 

```
sudo apt-mark unhold kubelet kubectl && \
sudo apt-get update && sudo apt-get install -y kubelet='1.32.2-*' kubectl='1.32.2-*' && \
sudo apt-mark hold kubelet kubectl
```

### Restart the kubelet

```
sudo systemctl daemon-reload
sudo systemctl restart kubelet
```

## Etcd backup and restore.

curl https://gist.githubusercontent.com/saiyam1814/ae9bf003bc4d89b90612ff757b5358db/raw/181870e70f50dd5f3103dabb00f26c1cf9bd368b/gistfile1.txt > backup.sh

### List etcd pods 

```
kubectl get pods -n kube-system | grep etcd
kubectl describe pod etcd-cplane-01  -n kube-system
```

### Install etcdctl

```
wget https://github.com/etcd-io/etcd/releases/download/v3.5.9/etcd-v3.5.9-linux-amd64.tar.gz
tar -xvf etcd-v3.5.9-linux-amd64.tar.gz
mv etcd-v3.5.9-linux-amd64/etcdctl /usr/local/bin/
mv etcd-v3.5.9-linux-amd64/etcdutl /usr/local/bin/
```
### Take a snapshot of etcd

```
sudo ETCDCTL_API=3 etcdctl --cacert=/etc/kubernetes/pki/etcd/ca.crt --cert=/etc/kubernetes/pki/etcd/server.crt --key=/etc/kubernetes/pki/etcd/server.key snapshot save /tmp/backup.db
<!-- Here the --cacert =--trusted-ca-file--cert =--cert-file and key =--key-file -->
```

### Restore the backup from the snapshot

```
sudo ETCDCTL_API=3 etcdutl --data-dir=/var/lib/restore snapshot restore /tmp/backup.db
```