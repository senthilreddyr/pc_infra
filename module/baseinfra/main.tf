provider "aws" {
  region = var.region
}


/* VPC */
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.environment}-vpc"
    Environment = "${var.environment}"
  }
}

/* Internet gateway for the public subnet */
resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.environment}-igw"
    Environment = "${var.environment}"
  }
}

/* Elastic IP for NAT */
resource "aws_eip" "nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.ig]
}

/* NAT */
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = element(aws_subnet.public_subnet.*.id, 0)
  depends_on    = [aws_internet_gateway.ig]

  tags = {
    Name        = "nat"
    Environment = "${var.environment}"
  }
}

/* Public subnet */
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.public_subnets_cidr)
  cidr_block              = element(var.public_subnets_cidr, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.environment}-${element(var.availability_zones, count.index)}-public-subnet"
    Environment = "${var.environment}"
    Type = "public"
  }
}

/* Private subnet */
resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.private_subnets_cidr)
  cidr_block              = element(var.private_subnets_cidr, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.environment}-${element(var.availability_zones, count.index)}-private-subnet"
    Environment = "${var.environment}"
    Type = "private"
  }
}

/* Routing table for private subnet */
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.environment}-private-route-table"
    Environment = "${var.environment}"
  }
}

/* Routing table for public subnet */
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.environment}-public-route-table"
    Environment = "${var.environment}"
  }
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ig.id
}

resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

/* Route table associations */
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets_cidr)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets_cidr)
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = aws_route_table.private.id
}
/* SECURITY GROUP */

resource "aws_security_group" "fe_lb" {
  name        = "fe_lb_sg"
  vpc_id      = aws_vpc.vpc.id
  depends_on  = [aws_vpc.vpc]
  description = "security group for fe load balancer"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["202.83.58.148/32"]
  }
  tags = {
    Name = "fe_lb_sg"
    Environment = "${var.environment}"
  }
}


resource "aws_security_group" "fe" {
  name        = "fe_sg"
  vpc_id      = aws_vpc.vpc.id
  depends_on  = [aws_vpc.vpc]
  description = "security group for fe instance"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.fe_lb.id]
  }
  tags = {
    Name = "fe_sg"
    Environment = "${var.environment}"
  }
}

resource "aws_security_group" "be_lb" {
  name        = "be_lb_sg"
  vpc_id      = aws_vpc.vpc.id
  depends_on  = [aws_vpc.vpc]
  description = "security group for fe load balancer"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "be_lb_sg"
    Environment = "${var.environment}"
  }
}

resource "aws_security_group" "be" {
  name        = "be_sg"
  vpc_id      = aws_vpc.vpc.id
  depends_on  = [aws_vpc.vpc]
  description = "security group for be instance"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 9966
    to_port         = 9966
    protocol        = "tcp"
    security_groups = [aws_security_group.be_lb.id]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.fe.id]
  }
  tags = {
    Name = "be_sg"
    Environment = "${var.environment}"
  }
}

resource "aws_security_group" "db" {
  name        = "db_sg"
  vpc_id      = aws_vpc.vpc.id
  description = "security group for load balancer"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.be.id]
  }

  depends_on = [
    aws_security_group.be
  ]
  tags = {
    Name = "db_sg"
    Environment = "${var.environment}"
  }
}

/* LOAD BALANCER */

/* FRONT END LOADBALANCER */
resource "aws_alb" "fe_alb" {
  name            = "pet-fe"
  internal        = false
  security_groups = [aws_security_group.fe_lb.id]
  subnets         = flatten([aws_subnet.public_subnet.*.id])
  tags = {
    Name = "fe-lb"
    Environment = "${var.environment}"
  }
}


resource "aws_alb_listener" "fe_alb_Listener" {
  load_balancer_arn = aws_alb.fe_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.fe_tg.arn
    type             = "forward"
  }
}

resource "aws_alb_target_group" "fe_tg" {
  name        = "fe-lb-tg"
  port        = "80"
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc.id
  health_check {
    path = "/petclinic/index.html"
  }
  tags = {
    Name = "fe-tg"
    Environment = "${var.environment}"
  }
}

/* BACKEND LOADBALANCER */
resource "aws_alb" "be_alb" {
  name            = "pet-be"
  internal        = false
  security_groups = [aws_security_group.be_lb.id]
  subnets         = flatten([aws_subnet.public_subnet.*.id])
  tags = {
    Name = "be-lb"
    Environment = "${var.environment}"
  }
}

resource "aws_alb_listener" "be_alb_Listener" {
  load_balancer_arn = aws_alb.be_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.be_tg.arn
    type             = "forward"
  }
}

resource "aws_alb_target_group" "be_tg" {
  name        = "be-lb-tg"
  port        = "9966"
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc.id

  health_check {
    path = "/petclinic/swagger-ui.html"
  }
  tags = {
    Name = "be-tg"
    Environment = "${var.environment}"
  }

}
