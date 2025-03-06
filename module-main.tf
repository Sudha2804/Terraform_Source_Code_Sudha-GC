provider "aws" {
  region = var.region
}

# Use Terraform workspaces for environment selection
locals {
  environment = terraform.workspace
  name_prefix = format("%s-%s", local.environment, "infra")
}

# VPC
resource "aws_vpc" "main" {
  cidr_block = var.cidr_block

  tags = {
    Name = format("%s-vpc", local.name_prefix)
  }
}

#  Subnet
resource "aws_subnet" "main" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_cidr_block
  map_public_ip_on_launch = true

  tags = {
    Name = format("%s-subnet", local.name_prefix)
  }
}

# Security Group (SSH & HTTP)
resource "aws_security_group" "allow_ssh" {
  name        = format("%s-sg", local.name_prefix)
  description = "Allow SSH and HTTP inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH Access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_ip]  # Restrict access
  }

  ingress {
    description = "HTTP Access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = format("%s-security-group", local.name_prefix)
  }
}

# EC2 Instance
resource "aws_instance" "web" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.main.id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  key_name               = var.key_name  # Ensure it's defined in AWS

  tags = {
    Name = format("%s-web-server", local.name_prefix)
  }
}
