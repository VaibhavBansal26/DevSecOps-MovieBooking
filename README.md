# DevSecOps-MovieBooking
Full Deployment Pipe - Terraform, EC2, Amazon EKS, Docker, Jenkins, SonarQube, Owasp, Trivy, AgroCD, Kubernetes

# System Architecture

![app](https://res.cloudinary.com/vaibhav-codexpress/image/upload/v1741897079/diagram-export-13-03-2025-16_12_04_ynag9b.png)


![jenkins](https://res.cloudinary.com/vaibhav-codexpress/image/upload/v1742055376/Screenshot_2025-03-15_at_12.12.30_PM_l0u2ek.png)

![sonar](https://res.cloudinary.com/vaibhav-codexpress/image/upload/v1742055374/Screenshot_2025-03-15_at_12.12.40_PM_kwue2x.png)

![prom1](https://res.cloudinary.com/vaibhav-codexpress/image/upload/v1742055477/Screenshot_2025-03-15_at_12.17.37_PM_dktbyr.png)

![prom2](https://res.cloudinary.com/vaibhav-codexpress/image/upload/v1742055377/Screenshot_2025-03-15_at_12.12.15_PM_tfvo9s.png)

![grafa](https://res.cloudinary.com/vaibhav-codexpress/image/upload/v1742055375/Screenshot_2025-03-15_at_12.12.01_PM_oukdbn.png)

![EKS](https://res.cloudinary.com/vaibhav-codexpress/image/upload/v1742055374/Screenshot_2025-03-15_at_12.15.16_PM_uf3smc.png)

![bms](https://res.cloudinary.com/vaibhav-codexpress/image/upload/v1742055376/Screenshot_2025-03-15_at_12.12.58_PM_vkvdu8.png)

![sg](https://res.cloudinary.com/vaibhav-codexpress/image/upload/v1742055371/Screenshot_2025-03-15_at_12.15.48_PM_zeuekv.png)

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


Administration -> User -> Create Sonar Token

Add this token in Jenkins -> Managae  Jenkins -> Security -> Credentials -> global

1. Add Sonar Token
2. Add Docker Credential
3. Add Email credentials

Create Sonarqube Webhook

Administration -> Configuration -> webhook - create

Create webhook so that SonarQube can interact with jenkins

webhook url: http://52.86.126.243:8080/sonarqube-webhook/


# Configuring Jenkins Tools

1. Configure java installations
2. Configure Sonarqueb Scanner
3. Configure Docker
4. Configure Node js
5. Configure owasp dependency check

# System Configuration

1. Sonarqube servers
2. Email for Notifications (smtp.gmail..com, port:465)
3. Default Content Type - html
4. Enable Default Triggers

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

**Install NPM**

```
sudo apt install npm
```

(b)

```
eksctl utils associate-iam-oidc-provider \
    --region us-east-1 \
    --cluster vb-eks \
    --approve

```

(c)

Before executing the below command, in the 'ssh-public-key' keep the  '<PEM FILE NAME>' (dont give .pem. Just give the pem file name) which was used to create Jenkins Server

```
eksctl create nodegroup --cluster=vb-eks \
                       --region=us-east-1 \
                       --name=node2 \
                       --node-type=t3.medium \
                       --nodes=3 \
                       --nodes-min=2 \
                       --nodes-max=4 \
                       --node-volume-size=20 \
                       --ssh-access \
                       --ssh-public-key=bms \
                       --managed \
                       --asg-access \
                       --external-dns-access \
                       --full-ecr-access \
                       --appmesh-access \
                       --alb-ingress-access
```




Before Building Jenkins Pipeline for deploying in Kubernetes

```
ps aux | grep jenkins
sudo -su jenkins
aws configure
aws sts get-caller-identity #verify user
exit
sudo systemctl restart jenkins
sudo -su jenkins
aws eks update-kubeconfig --name vb-eks --region us-east-1
```

# Monitoring Application using prometheus and graffana

Launch an EC2 instance for monitoring
t2.medium, AMI 22.04 version

SSHing in to EC2 (monitoring) Instance

```
sudo apt update
```

Connect to the Monitoring Server VM (Execute in Monitoring Server VM)

Create a dedicated Linux user sometimes called a 'system' account for Prometheus

```
sudo useradd \
    --system \
    --no-create-home \
    --shell /bin/false prometheus
```

Move the Prometheus binary and a promtool to the /usr/local/bin/. promtool is used to check configuration files and Prometheus rules.

```
sudo mv prometheus promtool /usr/local/bin/
```

Move console libraries to the Prometheus configuration directory

```
sudo mv consoles/ console_libraries/ /etc/prometheus/
```

Move the example of the main Prometheus configuration file

```
sudo mv prometheus.yml /etc/prometheus/prometheus.yml
```

Set the correct ownership for the /etc/prometheus/ and data directory

```
sudo chown -R prometheus:prometheus /etc/prometheus/ /data/
```

Delete the archive and a Prometheus tar.gz file 

```
cd
You are in ~ path
rm -rf prometheus-2.47.1.linux-amd64.tar.gz

prometheus --version
You will see as "version 2.47.1"

prometheus --help
```

We’re going to use Systemd, which is a system and service manager for Linux operating systems. For that, we need to create a Systemd unit configuration file.

```
sudo vi /etc/systemd/system/prometheus.service ---> Paste the below content ---->

[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target
StartLimitIntervalSec=500
StartLimitBurst=5
[Service]
User=prometheus
Group=prometheus
Type=simple
Restart=on-failure
RestartSec=5s
ExecStart=/usr/local/bin/prometheus \
  --config.file=/etc/prometheus/prometheus.yml \
  --storage.tsdb.path=/data \
  --web.console.templates=/etc/prometheus/consoles \
  --web.console.libraries=/etc/prometheus/console_libraries \
  --web.listen-address=0.0.0.0:9090 \
  --web.enable-lifecycle
[Install]
WantedBy=multi-user.target
```

```
#To automatically start the Prometheus after reboot run the below command

sudo systemctl enable prometheus


#Start the Prometheus

sudo systemctl start prometheus

#Check the status of Prometheus
sudo systemctl status prometheus

#Open Port No. 9090 for Monitoring Server VM and Access Prometheus, Also ADD 9090 in Security groups
54.234.81.159:9090
```

Click on 'Status' dropdown ---> Click on 'Targets' ---> You can see 'Prometheus (1/1 up)' ----> It scrapes itself every 15 seconds by default. target is jenkins


# Install Node Exporter (Execute in Monitoring Server VM)

You are in ~ path now

Create a system user for Node Exporter and download Node Exporter:

```
sudo useradd --system --no-create-home --shell /bin/false node_exporter
wget https://github.com/prometheus/node_exporter/releases/download/v1.6.1/node_exporter-1.6.1.linux-amd64.tar.gz

#Extract Node Exporter files, move the binary, and clean up:
tar -xvf node_exporter-1.6.1.linux-amd64.tar.gz
sudo mv node_exporter-1.6.1.linux-amd64/node_exporter /usr/local/bin/
rm -rf node_exporter*

node_exporter --version

```

Create a systemd unit configuration file for Node Exporter:

```
sudo vi /etc/systemd/system/node_exporter.service

Add the following content to the node_exporter.service file:
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

StartLimitIntervalSec=500
StartLimitBurst=5

[Service]
User=node_exporter
Group=node_exporter
Type=simple
Restart=on-failure
RestartSec=5s
ExecStart=/usr/local/bin/node_exporter --collector.logind

[Install]
WantedBy=multi-user.target

```

Note: Replace --collector.logind with any additional flags as needed.

Enable and start Node Exporter:

```
sudo systemctl enable node_exporter
sudo systemctl start node_exporter
```

Verify the Node Exporter's status:

```
sudo systemctl status node_exporter
```


**Configure Prometheus Plugin Integration**

As of now we created Prometheus service, but we need to add a job in order to fetch the details by node exporter. So for that we need to create 2 jobs, one with 'node exporter' and the other with 'jenkins' as shown below;

Integrate Jenkins with Prometheus to monitor the CI/CD pipeline.

Prometheus Configuration:

To configure Prometheus to scrape metrics from Node Exporter and Jenkins, you need to modify the prometheus.yml file. 
The path of prometheus.yml is; cd /etc/prometheus/ ----> ls -l ----> You can see the "prometheus.yml" file ----> sudo vi prometheus.yml ----> You will see the content and also there is a default job called "Prometheus" Paste the below content at the end of the file;

  - job_name: 'node_exporter'
    static_configs:
      - targets: ['<MonitoringVMip>:9100']

  - job_name: 'jenkins'
    metrics_path: '/prometheus'
    static_configs:
      - targets: ['<your-jenkins-ip>:<your-jenkins-port>']



Also replace the public ip of monitorting VM. Dont change 9100. Even though the Monitoring server is running on 9090, dont change 9100 in the above script

Check the validity of the configuration file:

```
promtool check config /etc/prometheus/prometheus.yml
```

Reload the Prometheus configuration without restarting:

```
curl -X POST http://localhost:9090/-/reload

Access Prometheus in browser (if already opened, just reload the page):
http://<your-prometheus-ip>:9090/targets

```

For Node Exporter you will see (0/1) in red colour. To resolve this, open Port number 9100 for Monitoring VM 


-------------------------------------------------------------------
6.4. Install Grafana (Execute in Monitoring Server VM)
-------------------------------------------------------------------
You are currently in /etc/Prometheus path.

```
Install Grafana on Monitoring Server;

Step 1: Install Dependencies:
First, ensure that all necessary dependencies are installed:


sudo apt-get update
sudo apt-get install -y apt-transport-https software-properties-common

```

```
Step 2: Add the GPG Key:
cd ---> You are now in ~ path
Add the GPG key for Grafana:
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -

```


```
Step 3: Add Grafana Repository:
Add the repository for Grafana stable releases:
echo "deb https://packages.grafana.com/oss/deb stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list

Step 4: Update and Install Grafana:
Update the package list and install Grafana:
sudo apt-get update
sudo apt-get -y install grafana

Step 5: Enable and Start Grafana Service:
To automatically start Grafana after a reboot, enable the service:

sudo systemctl enable grafana-server

Start Grafana:
sudo systemctl start grafana-server

Step 6: Check Grafana Status:
Verify the status of the Grafana service to ensure it's running correctly:
sudo systemctl status grafana-server


Step 7: Access Grafana Web Interface:
The default port for Grafana is 3000
http://<monitoring-server-ip>:3000

```

Default id and password is "admin"


You will see the Grafana dashboard

# Adding Data Source in Grafana
The first thing that we have to do in Grafana is to add the data source
Add the data source;


# Adding Dashboards in Grafana 
(URL: https://grafana.com/grafana/dashboards/1860-node-exporter-full/) 
Lets add another dashboard for Jenkins;
(URL: https://grafana.com/grafana/dashboards/9964-jenkins-performance-and-health-overview/)


```
kubectl get nodes
kubectl get svc
```




