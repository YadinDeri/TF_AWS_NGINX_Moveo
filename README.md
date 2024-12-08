# Deploy NGINX Using Terraform and AWS

## Description

The goal of this project is to deploy a Dockerized NGINX instance on AWS using Terraform and Docker. The NGINX server will be publicly accessible and display the message "yo this is nginx" when accessed via a browser. 
The infrastructure includes a Virtual Private Cloud (VPC) with both public and private subnets, an EC2 instance in the private subnet, security groups, and other necessary resources. 
The project uses the **AWS Free Tier** for all services.

This project demonstrates the use of Infrastructure as Code (IaC) for provisioning cloud resources with **Terraform** and containerization with **Docker** for deploying a web service.


## Tree structure 
```
TF_AWS_NGINX_MOVEO
├── Modules
│   ├── loadBalancer
│   │   ├── main.tf
│   │   ├── output.tf
│   │   └── variables.tf
│   ├── nginx_ec2
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   └── VPC
│       ├── main.tf
│       ├── output.tf
│       └── variables.tf
├── Dockerfile
├── main.tf
├── my-local-machine-moveo
├── my-local-machine-moveo.pub
├── outputs.tf
├── providers.tf
└── variables.tf
```

## 🚩 How to Start

Follow these steps to get the project up and running:

### 1. Clone the Repository

```bash
git clone https://github.com/TF_AWS_NGINX_Moveo.git
cd TF_AWS_NGINX_Moveo
```

### 2. Install Terraform & AWS CLI
Ensure that you have Terraform installed and AWS CLI on your local machine. If you don't have it yet, follow the installation guide for your platform


### 3. Set Up AWS Credentials
Ensure your AWS credentials are set up properly for Terraform to interact with your AWS account. You can configure the AWS CLI by running:

```bash
aws configure
```
Enter your AWS Access Key ID, Secret Access Key, region, and output format when prompted.


### 4. Terraform commands

Run the following command to initialize the Terraform working directory:
```bash
terraform init
```
Run terraform apply to provision the infrastructure:
```bash
terraform apply
```

### 5. Access the Application
After Terraform completes the deployment, you'll receive the URL of the NGINX server. 
Open a browser and navigate to the URL to see the text "yo this is nginx."

```bash
http://<your-URL>
```

##
## 📶 Modules in the project

This project is divided into the following Terraform modules:

### 1. loadBalancer
This module creates a load balancer (if necessary) to distribute traffic to the EC2 instance running the NGINX application.

### 2. nginx_ec2
This module provisions an EC2 instance in the private subnet with Docker installed, running the Dockerized NGINX application.

### 3. VPC
This module provisions the VPC with public and private subnets, routing tables




## 💡 Platforms

<img src="https://github.com/user-attachments/assets/aaba87d8-5406-41ce-ab18-c1d717d5631e" alt="terraform Logo" width="100"/>
<img src="https://github.com/user-attachments/assets/1d8a4774-9279-49a5-b5dd-3dff5f2af9b8" alt="Amazon Web Services Logo" width="100"/>
<img src="https://github.com/user-attachments/assets/6148a30a-6fd9-4461-af6b-1fb399ab2d79" alt="docker Logo" width="150"/>
<img src="https://github.com/user-attachments/assets/1b0da66f-968f-42a4-8963-95e67cc6fcac" alt="nginx Logo" width="100"/>

This project utilizes several technologies to deploy the infrastructure and application:

### 1. Terraform
Terraform is used to define and provision the AWS infrastructure as code. It manages the lifecycle of resources, including EC2 instances, VPCs, and security groups.

- [Terraform Documentation](https://www.terraform.io/docs)

### 2. Docker
Docker is used to containerize the NGINX application. It allows the NGINX server to be deployed consistently across different environments, including locally and on AWS.

- [Docker Documentation](https://docs.docker.com)

### 3. AWS

Amazon Web Services (AWS) is the cloud provider where the infrastructure is deployed. This project uses AWS EC2, VPC, Security Groups, and other services.

- [AWS Documentation](https://aws.amazon.com/documentation/)

### 4. NGINX
NGINX is a popular web server used in this project to serve a simple HTML page with the text "yo this is nginx."

- [NGINX Documentation](https://nginx.org/en/docs/)



## 🧠 Thought Process
I began by thoroughly reading and analyzing the task requirements. 
The primary objective was to deploy a Dockerized NGINX instance in a private subnet that would still be publicly accessible. 
This posed a challenge, as private subnets typically do not allow direct access from the internet.


### Exploring the Jump Server Approach
Initially, I considered creating two Virtual Machines (VMs):
* VM 1: In the public subnet to act as a "jump server."
* VM 2: In the private subnet hosting the Dockerized NGINX.

The idea was to route requests to the private VM through the public VM. 

After several hours of experimentation, I realized this approach required complex configurations, and I encountered issues implementing a stable solution. 
At this point, I decided to explore alternative approaches.

### Leveraging a Load Balancer
After further research, I shifted to using an Application Load Balancer (ALB) to handle public traffic. 
The solution works as follows:
1. The ALB is configured to listen on port 80 for incoming HTTP requests.
2. Requests reaching the ALB are automatically forwarded to the Target Group, which contains the EC2 instance hosting the NGINX application.
3. The Target Group communicates with the EC2 instance in the private subnet, ensuring that the NGINX application is accessible to the public while maintaining the security of the private subnet.

![image](https://github.com/user-attachments/assets/dfc1072c-7acf-45b9-9529-3bda1862aaa4)





