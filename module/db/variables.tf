variable "environment" {
  description = "The Deployment environment"
}

variable "region" {
  description = "The region to launch the bastion host"
}


#########DB#######

variable "db_password" {
  description = "The master password for the database"
  type        = string
}

variable "db_name" {
  description = "The name to use for the database"
  type        = string
  default     = "petclinic"
}

variable "db_user" {
  description = "The database username to use for the database"
  type        = string
}

variable "db_instance_class" {
  type    = string
  default = "db.t2.micro"
}