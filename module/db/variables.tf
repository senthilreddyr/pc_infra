variable "environment" {
  description = "Environment"
  type        = string
}

variable "region" {
  description = "AWS Region"
  type        = string
}

/* DB */

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

variable "db_instance_class" {
  type    = string
  default = "db.t2.micro"
}

variable "storage_type" {
  description = "DB Storage Type"
  type        = string
}

variable "parameter_group_name" {
  description = "DB Parameter group name"
  type        = string
}

variable "engine" {
  description = "DB engine"
  type        = string
}

variable "engine_version" {
  description = "DB engine version"
  type        = string
}