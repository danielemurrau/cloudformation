https://www.eksworkshop.com/

1. install eks
$ curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp

$ sudo mv /tmp/eksctl /usr/local/bin

$ eksctl version

2. install kubectl

$ curl -o kubectl https://s3.us-west-2.amazonaws.com/amazon-eks/1.23.7/2022-06-29/bin/linux/arm64/kubectl

$ sudo mv kubectl /usr/local/bin

3. create EKS cluster with eksctl

$ export AWS_PROFILE=dmitp

$ eksctl create cluster --name dmitp --region eu-west-1 --fargate

4. kubeconfig will be autmatically saved in /home/snip/.kube/config and you can use kubectl

$ kubectl get nodes

$ kubectl get pods -A

## deploy a sample application

1. create a namespace

$ kubectl create namespace eks-sample-app

2. create a deployment (see file in the repo eks-sample-deployment.yaml) adn a service (eks-sample-service.yaml) file

3. apply the deployment and the service

$ kubectl apply -f eks-sample-deployment.yaml
$ kubectl apply -f eks-sample-service.yaml

4. check if the pod is starting or is yet up and running 

$ kubectl get pods -n eks-sample-app

5. check all the resources in the namespace

$ kubectl get all -n eks-sample-app

$ kubectl -n eks-sample-app describe pod eks-sample-linux-deploy


eksctl create fargateprofile \
    --cluster dmitp-cluster \
    --name fp-eks-sample-app \
    --namespace eks-sample-app

6. delete cluster

$ eksctl delete cluster --name=dmitp-cluster --region=eu-west-1