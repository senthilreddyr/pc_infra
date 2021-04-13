provider "aws" {
  region = var.region
}

data "aws_vpc" "vpc" {
  tags = {
    Name = "dev-vpc"
  }
}

data "aws_db_instance" "database" {
  db_instance_identifier = var.db_name
}

data "aws_security_group" "be_sg" {
  name   = "be_sg"
  vpc_id = data.aws_vpc.vpc.id
}

data "aws_subnet_ids" "private_subnet" {
  vpc_id = data.aws_vpc.vpc.id
  tags = {
    Type = "*private*"
  }
}

data "aws_lb_target_group" "be_tg" {
  name = "be-lb-tg"
}

resource "aws_launch_configuration" "petclinic_be" {
  name_prefix     = "petclinic_be"
  image_id        = var.ami
  instance_type   = "t2.micro"
  security_groups = [data.aws_security_group.be_sg.id]
  key_name        = var.key_pair
  user_data_base64 = base64encode(templatefile("${path.module}/scripts/user_data_be.sh", {
    DATABASE_HOST     = "${data.aws_db_instance.database.endpoint}"
    DATABASE_NAME     = "${var.db_name}"
    DATABASE_USERNAME = "${var.db_user}"
    DATABASE_PASSWORD = "${var.db_password}"
  }))
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "petclinic_be_asg" {
  name                      = "petclinic_be_asg"
  max_size                  = 2
  min_size                  = 1
  health_check_grace_period = 120
  health_check_type         = "EC2"
  desired_capacity          = 1
  launch_configuration      = aws_launch_configuration.petclinic_be.name
  target_group_arns         = [data.aws_lb_target_group.be_tg.arn]
  vpc_zone_identifier       = data.aws_subnet_ids.private_subnet.ids
  tag {
    key                 = "Name"
    value               = "petclinic-be-asg"
    propagate_at_launch = true
  }
}
