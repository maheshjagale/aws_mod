# 1. Terraform Settings: Define the required AWS provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# 2. Provider Configuration: Set the AWS region
provider "aws" {
  # As requested, we are targeting the Mumbai region
  region = "ap-south-1" 
}

# 3. Call the VPC Module
# NOTE: Your VPC module must define an 'output' for vpc_id and subnet_id
module "my_vpc" {
  source = "./modules/vpc" 
  
  # Assuming your VPC module has a variable called 'vpc_name'
  vpc_name = "My-Application-VPC" 
  # Assuming your VPC module has a variable called 'cidr_block'
  cidr_block = "10.0.0.0/16" 
}

# 4. Call the EC2 Module
# This module uses outputs from the VPC module to ensure resources are created in the right network.
module "web_server" {
  source = "./modules/ec2" 
  
  # Passes values to the variables you defined in modules/ec2/variables.tf
  instance_name = "My-Prod-Web-Server"
  instance_type = "t2.micro" 
  
  # This relies on your VPC module having an output named 'public_subnet_id'
  subnet_id = module.my_vpc.public_subnet_id 
}
