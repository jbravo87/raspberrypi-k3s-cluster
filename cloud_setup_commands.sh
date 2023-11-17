# Server's IP addy
hostname -I

# Router's IP addy
ip r

# DNS IP addy
grep "nameserver" /etc/resolv.conf
# Get quick info on all nodes in my cluster
sudo kunectl get nodes
# (not sure)
sudo kubectl config current-context
# Check the contents of traefik.yaml file
sudo cat /var/lib/rancher/k3s/server/manifests/traefik.yaml
# Restart k3s
sudo systemctl restart k3s
# Get all active pods
kubectl get pods -A
# Create empty skip file
sudo touch /var/lib/rancher/k3s/server/manifests/traefik.yaml.skip

sudo kubectl get all -A | grep traefik

# Friday, November 3, 2023
# Removing k3s from agent and master nodes
# To uninstall K3s from an agent node, run:
/usr/local/bin/k3s-agent-uninstall.sh
# To uninstall K3s from a server node, run:
/usr/local/bin/k3s-uninstall.sh
# Update packages
sudo apt update -y
# Upgrade packages
sudo apt upgrade -y

# Install Docker on the K3s node
curl https://releases.rancher.com/install-docker/20.10.sh | sh
# Check for OS container features enabled
sudo docker info
# Reboot after installation
sudo reboot
# Install k3s securely without traefik
sudo curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--disable=traefik" K3S_KUBECONFIG_MODE="644" sh -s - --docker
# Confirm the cluster is available
sudo k3s kubectl get pods --all-namespaces
# Confirm that the Docker containers are running
sudo docker ps
# Check k3s status
sudo systemctl status k3s

# Admin credentials
cat /etc/rancher/k3s/k3s.yaml

# Add worker nodes
# Grab token so worker nodes can join cluster
sudo cat /var/lib/rancher/k3s/server/node-token

#Don't forget to replace $YOUR_SERVER_NODE_IP and $YOUR_CLUSTER_TOKEN
curl -sfL https://get.k3s.io | K3S_URL=https://$YOUR_SERVER_NODE_IP:6443 K3S_TOKEN=$YOUR_CLUSTER_TOKEN sh -
# e.g.
curl -sfL https://get.k3s.io | K3S_URL=https://10.0.0.172:6443 K3S_TOKEN=K109a2b444bb4750626bc9b5f7f047683faef3e8f7a7f1d747cc3585405658bd7ac::server:9c9e62d977343b66d4636cf603dad83d sh -

# Installing via manifest MetalLB load balancer
# Following was obtained from MetalLB official site
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.12/config/manifests/metallb-native.yaml
# Apply configuration
kubectl apply -f address-pool.yaml
# CHeck if services are up and running
kubectl get pods -n metallb-system -o wide

# Install Nginx Ingress with using YAML manifest
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.2/deploy/static/provider/cloud/deploy.yaml
# Few pods should've started in ingress-nginx namespace
kubectl get pods --namespace=ingress-nginx
# ollowing command will wait for the ingress controller pod to be up, running, and ready
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=120s


# Install inginx-ingress using helm
sudo kubectl create ns ingress-nginx
sudo kubens ingress-nginx

$ helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
$ helm repo update
$ helm install ingress-nginx ingress-nginx/ingress-nginx

# Show disk space in human-readable format
df -h

# Shows disk size along with disk partitioning information
sudo fdisk -l
lsblk

# Create new partition on empty disk
sudo fdisk /dev/sdX
# Commands following are:
# n
# p
# 3 default options
# AND w to write the changes to disk
# Only creating one partition for this primary drive

# Now, add filesystem to SSD
# Use following to locate new partition and device path
sudo fdisk -l

# Format disk using EXT filesystem
sudo mkfs -t ext4 /dev/sdX1

# Use the mount command to mount the newly formatted partition on our system
sudo mkdir -p /media/external_ssd
sudo mount /dev/sda1 /media/external_ssd

# Double-check specifying the correct partition
sudo mkfs.ext4 /dev/sdXY

# Link a drive to another drive
ln -s MOUNT_LOCATION LINK_LOCATION
ln -s /media/external_ssd ~/external_ssd