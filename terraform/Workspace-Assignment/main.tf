terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket54"
    key           = "terraform/dev/terraform.tfstate"
    region        = "ap-south-1"
   # dynamodb_table = "terraform-lock"
    #encrypt       = true
  }
}

provider "aws" {
  region = "ap-south-1"
}

locals {
  environment = terraform.workspace
  bucket_name = "${terraform.workspace}-my-app-bucket"

  instance_type = lookup(
    {
      dev     = "t2.micro"
      staging = "t3.small"
      prod    = "t3.medium"
    },
    terraform.workspace,
    "t2.micro" # Default to t2.micro if workspace is unrecognized
  )
}

resource "aws_s3_bucket" "app_bucket" {
  bucket = local.bucket_name
   force_destroy = true

  tags = {
    Name        = local.bucket_name
    Environment = local.environment
  }
}

resource "aws_instance" "app_server" {
  ami           = "ami-00bb6a80f01f03502" # Example AMI, update as needed
  instance_type = local.instance_type

  tags = {
    Name        = "ec2-${local.environment}"
    Environment = local.environment
  }
}
