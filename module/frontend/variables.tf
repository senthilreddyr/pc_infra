variable "environment" {
  description = "Environment"
}

variable "region" {
  description = "AWS Region"
}

variable "ami" {
  description = "AMI"
  type        = string
}

variable "key_pair" {
  description = "Instance ssh key"
  default = "jenkins"
}

variable "instance_type" {
  description = "Ec2 instance Type"
  type        = string
}