provider "aws" {
  region = var.region
}

module "ec2_instance" {
  source = "github.com/Sudha2804/Terraform_Source_Code_Sudha-GC//module-main.tf"  # Replace with your GitHub repo

  region             = var.region
  cidr_block        = var.cidr_block
  subnet_cidr_block = var.subnet_cidr_block
  allowed_ssh_ip    = var.allowed_ssh_ip
  ami               = var.ami
  instance_type     = var.instance_type
  key_name          = var.key_name
}