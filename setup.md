# AHL Logics DevOps Terraform Task Setup Guide

## Table of Contents
1. [Prerequisites](#prerequisites)
2. [Project Structure](#project-structure)
3. [Setup Instructions](#setup-instructions)
4. [Terraform Components](#terraform-components)

## Prerequisites

Before running this Terraform code, ensure you have the following installed:

- [Terraform CLI](https://www.terraform.io/downloads) (v1.5.0 or later)
- [AWS CLI](https://aws.amazon.com/cli/)
- An AWS account with the necessary permissions to create VPCs, EC2 instances, IAM roles, CloudWatch, and SNS topics.
- SSH key pair if you want to access EC2 instances (optional).

## Project Structure

The project consists of the following files:

```plaintext
├── main.tf                # Main Terraform configuration file
├── variables.tf           # Variables used in the Terraform configuration
├── outputs.tf             # Outputs from the Terraform resources
├── .gitignore             # Git ignore file to exclude unnecessary files
├── setup.md               # Setup instructions and documentation (this file)
└── plan_output.txt        # Terraform plan output (optional)
```
## Setup Instructions

### 1. Clone the Repository
First, clone this repository to your local machine:

```bash
git clone https://github.com/ahl-devops-task.git
cd ahl-devops-task
```

### 2. Configure AWS CLI
Make sure your AWS CLI is configured with the necessary credentials:

```bash
aws configure
```

### 3. Initialize Terraform
Initialize the Terraform project to install the necessary providers and modules:

```bash
terraform init
```

### 4. Review and Modify Variables
Review the variables.tf file to ensure that all variables match your desired configuration. If needed, create a terraform.tfvars file to override default variable values.

### 5. Generate a Terraform Plan
Create a Terraform execution plan to preview the changes that Terraform will make:

```bash
terraform plan -out=tfplan
```
(Optional) View the human-readable plan:
```bash
terraform show -no-color tfplan > plan_output.txt
```

### 6. Apply the Terraform Plan
Apply the Terraform plan to create the infrastructure:

```bash
terraform apply
```

### 7. Access Your Infrastructure
After Terraform completes, you can use the output values to access your resources. For example, if public IPs are output, you can SSH into the EC2 instances.

### 8. Clean Up
To destroy the resources created by Terraform, run:

```bash
terraform destroy
```

## Terraform Components

### 1. VPC and Subnets
- **VPC**: A virtual private cloud that isolates our infrastructure. This VPC is divided into public and private subnets.
- **Public Subnet**: Hosts the API server that is accessible from the internet.
- **Private Subnet**: Hosts the Database server, which is only accessible from the public subnet or through specific security groups.

### 2. Security Groups
- **Web Security Group**: Allows inbound HTTP (port 80) and HTTPS (port 443) traffic to the API server.
- **Database Security Group**: Restricts access to the database server to only traffic from within the VPC or specifically allowed subnets.

### 3. EC2 Instances
- **API Server**: An EC2 instance running in the public subnet, accessible via HTTP/HTTPS.
- **Database Server**: An EC2 instance running in the private subnet, only accessible by the API server.

### 4. CloudWatch and SNS
- **CloudWatch Logs**: Centralized logging for the API and Database servers.
- **CloudWatch Alarms**: Monitors CPU utilization and triggers alerts if thresholds are exceeded.
- **SNS Topic**: Sends email alerts when CloudWatch alarms are triggered.

### 5. Outputs
Outputs provide key information such as the public IP addresses of EC2 instances, which can be used to access the deployed services.
