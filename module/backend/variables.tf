variable "environment" {
  description = "Environment"
  type        = string
}

variable "region" {
  description = "AWS Region"
  type        = string
}

variable "ami" {
  description = "AMI"
  type        = string
}

variable "instance_type" {
  description = "Ec2 instance Type"
  type        = string
}

variable "key_pair" {
  default = "jenkins"
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

#########DB#######

variable "db_password" {
  description = "Database Password"
  type        = string
}

variable "db_name" {
  description = "Database Name"
  type        = string
  default     = "petclinic"
}

variable "db_user" {
  description = "Database Username"
  type        = string
}