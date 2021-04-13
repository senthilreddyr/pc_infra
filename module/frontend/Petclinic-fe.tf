provider "aws" {
  region = var.region
}

data "aws_vpc" "vpc" {
  tags = {
    Name = "dev-vpc"
  }
}

data "aws_security_group" "fe_sg" {
  name   = "fe_sg"
  vpc_id = data.aws_vpc.vpc.id
}

data "aws_subnet_ids" "public_subnet" {
  vpc_id = data.aws_vpc.vpc.id
  tags = {
    Type = "*public*"
  }
}

data "aws_lb_target_group" "fe_tg" {
  name = "fe-lb-tg"
}

resource "aws_launch_configuration" "petclinic_fe" {
  name_prefix          = "petclinic_fe"
  image_id             = var.ami
  instance_type        = "t2.micro"
  security_groups      = [data.aws_security_group.fe_sg.id]
  key_name             = var.key_pair
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "petclinic_fe_asg" {
  name                      = "petclinic_fe_asg"
  max_size                  = 2
  min_size                  = 1
  health_check_grace_period = 120
  health_check_type         = "EC2"
  desired_capacity          = 1
  launch_configuration      = aws_launch_configuration.petclinic_fe.name
  target_group_arns         = [data.aws_lb_target_group.fe_tg.arn]
  vpc_zone_identifier       = data.aws_subnet_ids.public_subnet.ids
  tag {
    key                 = "Name"
    value               = "petclinic-fe-asg"
    propagate_at_launch = true
  }
}