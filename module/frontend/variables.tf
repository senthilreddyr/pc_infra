variable "environment" {
  description = "The Deployment environment"
}

variable "region" {
  description = "The region to launch the bastion host"
}

variable "ami" {
  # default = "ami-0729911f6d7f3f1db"
}

variable "key_pair" {
  default = "jenkins"
}