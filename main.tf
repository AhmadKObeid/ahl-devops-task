provider "aws" {
    region = var.region
}

# VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "main-vpc"
  }
}

# Subnets
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet"
  }
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidr

  tags = {
    Name = "private-subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

# Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Security Groups

# web security group exposing http & https ports
resource "aws_security_group" "web_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-security-group"
  }
}

# database securtiy group (assuming its a postgres db)
resource "aws_security_group" "db_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.private.cidr_block]
  }

  tags = {
    Name = "db-security-group"
  }
}

# EC2 Instances
resource "aws_instance" "api" {
  ami           = var.api_ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public.id
  security_groups = [aws_security_group.web_sg.name]

  tags = {
    Name = "api-server"
  }
}

resource "aws_instance" "db" {
  ami           = var.db_ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.private.id
  security_groups = [aws_security_group.db_sg.name]

  tags = {
    Name = "db-server"
  }
}

# CloudWatch Logs
resource "aws_cloudwatch_log_group" "api_log_group" {
  name              = "/aws/api-server"
  retention_in_days = 14
}

resource "aws_cloudwatch_log_group" "db_log_group" {
  name              = "/aws/db-server"
  retention_in_days = 14
}

# CloudWatch Alarms
resource "aws_cloudwatch_metric_alarm" "cpu_high_api" {
  alarm_name          = "api-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"

  alarm_description = "This metric monitors high CPU utilization"
  actions_enabled   = true

  dimensions = {
    InstanceId = aws_instance.api.id
  }

  alarm_actions = [aws_sns_topic.alerts.arn]
}

resource "aws_sns_topic" "alerts" {
  name = "alerts-topic"
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

