# DevSecOps-MovieBooking
Full Deployment Pipe - Terraform, EC2, Amazon EKS, Docker, Jenkins, SonarQube, Owasp, Trivy, AgroCD, Kubernetes


Configure Infrastructure in AWS using Terraform

1. Provisioning resources in AWS

Creation of IAM User

Terraform SCript -> aws configure

```
cd Terraform

terraform init

```

```
brew install terraform
which terraform
source ~/.zshrc

```

```
terraform plan # information of the resources we are going to create
```

```
terraform apply --auto-approve
```

**To give permissions to a file**

```
sudo chmod +x executable_file.sh
```

**To give permissions to a docker**

```
sudo chmod 666 /var/run/docker.sock
```

Docker login

```
docker login -u vaibhavbansal26
```

**Root user**
```
sudo su

 whoami
```

SSHing EC2 Instance

```
ssh -i "bms.pem" ubuntu@ec2-52-86-126-243.compute-1.amazonaws.com
```


# Jenkins (PORT:8080)

```
sudo systemctl status jenkins
```

Jenkins URL = http://52.86.126.243:8080/

**Get password & Install Plugins**

```
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

Install the Plugins

Install the Available Plugins

1. Jenkins Plugins
2. Eclipse Temurin installerVersion 1.7
3. SonarQube ScannerVersion 2.18
4. NodeJSVersion 1.6.4
5. OWASP Dependency-CheckVersion 5.6.0
6. Docker Version 1274.vc0203fdf2e74
7. Docker Commons Version 451.vd12c371eeeb_3
8. Docker Pipeline
9. Docker API
10. docker-build-step
11. Pipeline: Stage View
12. Pipeline Aggregator View
13. Prometheus metrics
14. Email Extension TemplateVersion
15. Kubernetes Client API
16. Kubernetes Credentials
17. Kubernetes
18. Kubernetes CLI
19. Kubernetes Credential Provider
20. Email Extension Template
21. Config File Provider
22. Prometheus metrics

# SonarQube

**Installation using docker**

Already Provisioned usinf Terraform Main.tf file

```
docker run -d --name sonar -p 9000:9000 sonarqube:lts-community
```

SonarQube : http://52.86.126.243:9000/

# CREATION OF EKS CLUSTER
=================================================

CREATE IAM User with these Permissions

1. AmazonEC2FullAccess
2. IAMFullAccess
3. AmazonEKS_CNI_Policy
4. AmazonEKSClusterPolicy
5. AmazonEKSWorkerNodePolicy
6. AWSCloudFormationFullAccess

Add Inline Policy

```
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "VisualEditor0",
			"Effect": "Allow",
			"Action": "eks:*",
			"Resource": "*"
		}
	]
}
```

# Install AWS CLI

aws.sh

```
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo apt install unzip
unzip awscliv2.zip
sudo ./aws/install
aws configure
```

```
sudo chmod +x aws.sh

./aws.sh

aws --version
```

# AWS Configure

```
aws configure
```

# Kubectl Installations

```
vi kubectl.sh

# Insert

curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.19.6/2021-01-05/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin
kubectl version --short --client
```

```
sudo chmod +x kubectl.sh
./kubectl.sh
```

# Install Eksctl

```
vi kubectl.sh

# Insert

curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
eksctl version
```

```
sudo chmod +x eksct.sh
./eksctl.sh
```

# Create EKS Cluster
===============================================================

Execute the below commands as separate set

(a)

```
eksctl create cluster --name=vb-eks \
                      --region=us-east-1 \
                      --zones=us-east-1a,us-east-1b \
                      --version=1.30 \
                      --without-nodegroup
```

It will take 5-10 minutes to create the cluster
Goto EKS Console and verify the cluster.

(b)

```
eksctl utils associate-iam-oidc-provider \
    --region us-east-1 \
    --cluster kastro-eks \
    --approve

```

(c)

Before executing the below command, in the 'ssh-public-key' keep the  '<PEM FILE NAME>' (dont give .pem. Just give the pem file name) which was used to create Jenkins Server

```
eksctl create nodegroup --cluster=kastro-eks \
                       --region=us-east-1 \
                       --name=node2 \
                       --node-type=t3.medium \
                       --nodes=3 \
                       --nodes-min=2 \
                       --nodes-max=4 \
                       --node-volume-size=20 \
                       --ssh-access \
                       --ssh-public-key=Kastro \
                       --managed \
                       --asg-access \
                       --external-dns-access \
                       --full-ecr-access \
                       --appmesh-access \
                       --alb-ingress-access
```








