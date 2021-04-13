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