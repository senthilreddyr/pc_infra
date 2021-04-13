data "aws_region" "current" {}

provider "aws" {
  region = var.region
}

locals {
  az1 = "${data.aws_region.current.name}a"
}

data "aws_vpc" "vpc" {
  tags = {
    Name = "dev-vpc"
  }
}

data "aws_subnet_ids" "private_subnet" {
  vpc_id = data.aws_vpc.vpc.id
  tags = {
    Type = "*private*"
  }
}

resource "aws_db_subnet_group" "subnet_group" {
  name       = "private subnet group"
  subnet_ids = data.aws_subnet_ids.private_subnet.ids
}

data "aws_security_group" "db_sg" {
  name = "db_sg"
  vpc_id = data.aws_vpc.vpc.id
}

resource "aws_db_instance" "pgdb" {
  allocated_storage       = 10
  storage_type            = "gp2"
  engine                  = "postgres"
  engine_version          = "12.5"
  identifier              = var.db_name
  instance_class          = var.db_instance_class
  name                    = var.db_name
  username                = var.db_user
  password                = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.subnet_group.id
  parameter_group_name    = "default.postgres12"
  skip_final_snapshot     = true
  deletion_protection     = false
  backup_retention_period = 0
  availability_zone       = local.az1
  vpc_security_group_ids  = [data.aws_security_group.db_sg.id]
  tags = {
    Environment = "${var.environment}-db"
    Name = "pet-db"
  }
}