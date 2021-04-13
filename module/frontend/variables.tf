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

variable "instance_max_count" {
  description = "instance maximum count"
  type        = string
}

variable "instance_min_count" {
description = "instance minimum count"
  type        = string
}

variable "desired_capacity" {
description = "running instance desired_capacity"
  type        = string
}