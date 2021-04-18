provider "aws" {
  region = var.region
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
  storage_type            = var.storage_type
  engine                  = var.engine
  engine_version          = var.engine_version
  identifier              = var.db_name
  instance_class          = var.db_instance_class
  name                    = var.db_name
  username                = var.db_user
  password                = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.subnet_group.id
  parameter_group_name    = var.parameter_group_name
  skip_final_snapshot     = true
  deletion_protection     = false
  backup_retention_period = 0
  availability_zone       = "${var.region}a"
  vpc_security_group_ids  = [data.aws_security_group.db_sg.id]
  tags = {
    Environment = "${var.environment}-db"
    Name = "pet-db"
  }
}