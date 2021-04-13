variable "environment" {
  description = "Environment"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for vpc"
  type        = string
}

variable "public_subnets_cidr" {
  description = "CIDR block for public subnet"
  type        = list
}

variable "private_subnets_cidr" {
  description = "CIDR block for private subnet"
  type        = list
}

variable "region" {
  description = "AWS Region"
  type        = string
}

variable "availability_zones" {
  description = "az for resource"
  type        = list
  default = ["ap-south-1a", "ap-south-1b"]
}