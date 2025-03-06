Take etcd backup and then add the backup to /tmp/backup.db
---
kubectl get pods -n kube-system | grep etcd
kubectl describe pod etcd-cplane-01  -n kube-system

wget https://github.com/etcd-io/etcd/releases/download/v3.5.9/etcd-v3.5.9-linux-amd64.tar.gz
tar -xvf etcd-v3.5.9-linux-amd64.tar.gz
mv etcd-v3.5.9-linux-amd64/etcdctl /usr/local/bin/
mv etcd-v3.5.9-linux-amd64/etcdutl /usr/local/bin/

sudo ETCDCTL_API=3 etcdctl --cacert=/etc/kubernetes/pki/etcd/ca.crt --cert=/etc/kubernetes/pki/etcd/server.crt --key=/etc/kubernetes/pki/etcd/server.key snapshot save /tmp/backup.db
Here the --cacert =--trusted-ca-file--cert =--cert-file and key =--key-file

restore
sudo ETCDCTL_API=3 etcdctl --data-dir=/var/lib/restore snapshot restore /tmp/backup.db