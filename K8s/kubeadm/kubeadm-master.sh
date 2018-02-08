#!/bin/bash
# This script is downloaded and called by kubeadm-new-cluster.sh to run on the master machine
# This must be run as root / sudo

# Install Docker 1.13
apt-get update
apt-get install -y docker.io

# Make sure that the cgroup driver used by kubelet is the same as the one used by Docker
cat << EOF > /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"]
}
EOF

# Installing kubeadm, kubelet and kubectl
apt-get update && apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update
apt-get install -y kubelet kubeadm kubectl

# Restart kubelet and wait for 10 minutes
servicectl restart kubelet
sleep 600

# Update all packages
apt-get update && apt-get upgrade

# Initialised cluster with network option for Canal
kubeadm init --pod-network-cidr=10.244.0.0/16

# Allow kubectl to be run by non-root users
export KUBECONFIG=/etc/kubernetes/admin.conf

# Install the Canal pod network
kubectl apply -f https://raw.githubusercontent.com/projectcalico/canal/master/k8s-install/1.7/rbac.yaml
kubectl apply -f https://raw.githubusercontent.com/projectcalico/canal/master/k8s-install/1.7/canal.yaml