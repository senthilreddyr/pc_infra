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


#########DB#######

variable "db_password" {
  description = "The master password for the database"
  type        = string
  # default     = "petclinic"
}

variable "db_name" {
  description = "The name to use for the database"
  type        = string
  default     = "petclinic"
}

variable "db_user" {
  description = "The database username to use for the database"
  type        = string
  # default     = "postgres"
}