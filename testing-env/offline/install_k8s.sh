#!/usr/bin/env bash

echo "----- DOWNLOADING K8S -----"
yumdownloader --resolve kubelet kubeadm kubectl
mkdir ~/dest/rpms/k8s
mv ./*.rpm ~/dest/rpms/k8s/.
echo "Kubernetes package (kubelet, kubeadm, kubectl) are saved to '~/dest/yums/k8s.tar.gz'"

echo "----- DOWNLOADING K8S IMAGES -----"
docker pull k8s.gcr.io/kube-apiserver:v1.18.0
docker pull k8s.gcr.io/kube-controller-manager:v1.18.0
docker pull k8s.gcr.io/kube-scheduler:v1.18.0
docker pull k8s.gcr.io/kube-proxy:v1.18.0
docker pull k8s.gcr.io/pause:3.2
docker pull k8s.gcr.io/etcd:3.4.3-0
docker pull k8s.gcr.io/coredns:1.6.7

docker save k8s.gcr.io/kube-apiserver:v1.18.0 > ~/dest/images/kube-apiserver.docker.tar
docker save k8s.gcr.io/kube-controller-manager:v1.18.0 > ~/dest/images/kube-controller-manager.docker.tar
docker save save k8s.gcr.io/kube-scheduler:v1.18.0 > ~/dest/images/kube-scheduler.docker.tar
docker save k8s.gcr.io/kube-proxy:v1.18.0 > ~/dest/images/kube-proxy.docker.tar
docker save k8s.gcr.io/pause:3.2 > ~/dest/images/pause.docker.tar
docker save k8s.gcr.io/etcd:3.4.3-0 > ~/dest/images/etcd.docker.tar
docker save k8s.gcr.io/coredns:1.6.7 > ~/dest/images/coredns.docker.tar
echo "k8s related docker image are saved to '~/dest/images/*'"

echo "----- DOWNLOADING CALICO -----"
wget https://github.com/projectcalico/calico/releases/download/v3.22.1/release-v3.22.1.tgz
tar -xvzf release-v3.22.1.tgz
cd ./release-v3.22.1
cp ./images/* ~/dest/images/.
echo "calico related docker image are saved to '~/dest/images/*'"
sed -i 's/docker.io\///g' ./manifests/calico.yaml
cp ./manifests/* ~/dest/manifests/.
cd ..
rm -rf ./release-v3.22.1.tgz ./release-v3.22.1
echo "calico manifests are saved to '~/dest/manifests/*'"