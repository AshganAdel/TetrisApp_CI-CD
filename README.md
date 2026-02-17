#  🚀Terraform AWS Infrastructure Deployment 

This project deploys a complete AWS infrastructure including VPC, EC2 instance, Security Groups, EKS cluster, and ECR repository using Terraform. The deployment uses modules for reusability and stores state securely in S3 with DynamoDB for locking.
 Terraform AWS Infrastructure – Detailed Documentation

📐 **Architecture Diagram:** 

Here is the main architecture of the project:
![Architecture Diagram](https://drive.google.com/uc?export=view&id=1HKmOLXlfygEcMnTrHGCBOmLEUaT1gc0H)

# 📌 Table of Contents

 1. 🧰 Prerequisites

2. 🗂️ Project Structure

3. 🧩 Modules Overview

    - 🌐 VPC

    - 🖥️ EC2

    - 🔐 Security Group

    - ☸️ EKS

    - 📦 ECR

4- ⚙️ Variables

5- 💾 Terraform Backend

6- ▶️ How to Run

7- 🧪 Example Deployment Flow


# 🧰 Prerequisites

  Before running this project, make sure you have:

1- Terraform v1.5+

2- AWS CLI configured (aws configure)

3- AWS account with IAM permissions

4- Existing:

   - 🪣 S3 bucket (for state)

  - 🔒 DynamoDB table (for state locking)

5- EC2 Key Pair (for SSH access)

# 🗂️ Project Structure
 ```text
.
├── main.tf              # Calls all modules
├── variables.tf         # Variable definitions
├── terraform.tf         # Backend configuration
├── terraform.tfvars     # Actual variable values
└── modules/
    ├── vpc/
    ├── ec2/
    ├── security_group/
    ├── eks/
    └── ecr/
```
# 🧩 Modules Overview
1- **🌐 VPC Module**

📍 Path: modules/vpc
  
  Creates:
   - VPC
   - Public subnet
   - Private subnets
   - Internet Gateway
   - NAT Gateway
  
  Inputs:

    Variable                 	Description
    cidr_vpc	                VPC CIDR block
    cidr_private	            List of private subnet CIDRs
    public_subnet_cidr      	Public subnet CIDR
    name_private	            Names of private subnets
    name_public	             Name of public subnet
    vpc_name	                VPC name
    igw	                     Internet Gateway name

 Outputs:

   - vpc_id
   -  private_subnet_id
   -   public_subnet_id
     
2- **🖥️ EC2 Module**

📍 Path: modules/ec2
  
  Creates:
   - EC2 instance in public subnet

  Inputs:

    Variable	                  Description
    subnet_id	                  Subnet ID
    public_ip_or_not	           Assign public IP
    ami                        	AMI ID
    volume_size	                Root volume size (GB)
    key_name	                   SSH key name
    instance_type	              EC2 instance type
    security_group_ids	         Security group IDs
    ec2_names	                  Instance names


3- **🔐 Security Group Module**

📍 Path: modules/security_group
   
  Creates:
   - Security group attached to the VPC
   
  Inputs:

    Variable	        Description
    vpc_id            	VPC ID
    vpc_cidr	          CIDR for inbound rules
  
  Outputs:
   
   - 🔑 sg_id
     
4-   **☸️ EKS Module**

 📍 Path: modules/eks
   
   Creates:
   - EKS Cluster
    
   - Managed Node Group
   
   Inputs:

    Variable                       	Description
    eks_subnets_ids	             Control plane subnets
    eks_nodes_subnets_ids	       Node group subnets
    security_group_ids	          Security groups
    enable_private_access	       Private API access
    enable_public_access	        Public API access
    nodes_ec2_type	Node          instance types
    node_group_name	             Node group name
    min_nodes	                   Min nodes
    max_nodes	                   Max nodes
    desired_nodes	               Desired nodes
    k8s_version	                 Kubernetes version
    cluster_name                 Cluster name

5-  **📦 ECR Module**

📍 Path: modules/ecr
  
  Creates:
   - Amazon ECR repository
   
   Inputs:
    
    Variable	             Description
    ecr_name	           Repository name
    
   Outputs:
   - 📎 Repository URI


# ⚙️ Variables
   ```sh
   variable "region" {}
   variable "vpc_cidr" {}
   variable "private_subnets_cidr" {}
   variable "public_subnets_cidr" {}
   variable "private_subnets_names" {}
   variable "public_subnets_names" {}
   variable "vpc_name" {}
   variable "igw_name" {}
   ```
 **📄 terraform.tfvars Example**
   ```sh
   region = "eu-north-1"
   
   vpc_cidr = "10.44.0.0/16"
   
   private_subnets_cidr = [
     "10.44.1.0/24",
     "10.44.2.0/24",
     "10.44.4.0/24"
   ]
   
   public_subnets_cidr = "10.44.3.0/24"
   
   private_subnets_names = [
     "private-subnet-a",
     "private-subnet-b",
     "private-subnet-c"
   ]
   
   public_subnets_names = "public-subnet"
   
   vpc_name = "eks-vpc"
   igw_name = "igw"

   ```

# 💾 Terraform Backend
  Remote backend configuration:
  ```hcl
   terraform {
     backend "s3" {
       bucket         = "terr-statefile-bucket2"
       key            = "state/file.tfstate"
       region         = "eu-north-1"
       dynamodb_table = "lock_table"
       encrypt        = true
     }
   }
  ```
3 ▶️ How to Run
```sh
terraform init
terraform plan
terraform apply
``` 

# 🧹 To destroy:
```sh
terraform destroy
```

# 🧪 Example Deployment Flow
   1️⃣ Create VPC
   
   2️⃣ Create subnets & IGW
   
   3️⃣ Create Security Group
   
   4️⃣ Launch EC2 in public subnet
   
   5️⃣ Deploy EKS cluster in private subnets
   
   6️⃣ Create ECR repository
