#!/bin/bash
# This script assumes public keys have been placed on the kubernetes machines

echo "IP of the Master:"
read masterIP

echo "IPs of the Nodes:"
read -a nodeIP

echo "Master IP Address: $masterIP"
echo "Number of Nodes: $#nodeIP[@]}"
echo "Node IP Addresses: ${nodeIP[*]}"


# Connect to master and download launch script
ssh $masterIP 'sudo curl -O https://raw.githubusercontent.com/TommyKTheDJ/k8sdemo/master/K8s/kubeadm-master.sh'

# Connect to master and change permissions on script
ssh $masterIP 'sudo chmod 700 kubeadm-master.sh'

# Connect to master and run launch script
ssh $masterIP 'sudo ./kubeadm-master.sh'

echo "Enter the kubeadm join command:"
read joinCmd

# Connect to each node and join the cluster
nodeCount = ${nodeIP[@]}
for (( i=0; i<${nodeCount}; i++ ));
do
	echo "Joining node with IP ${nodeIP[$i]} to the cluster"
	ssh ${nodeIP[$i]} $joinCmd
done