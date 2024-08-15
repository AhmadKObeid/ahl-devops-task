variable "region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "The CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "The CIDR block for the private subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "api_ami" {
  description = "AMI ID for the API server"
  type        = string
  default     = "ami-0c55b159cbfafe1f0"
}

variable "db_ami" {
  description = "AMI ID for the Database server"
  type        = string
  default     = "ami-0c55b159cbfafe1f0"
}

variable "alert_email" {
  description = "Email address for CloudWatch alerts"
  type        = string
  default     = "ahmadkobeid96@gmail.com"
}

