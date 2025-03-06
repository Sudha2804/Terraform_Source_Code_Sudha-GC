output "vpc_id" {
  description = "The ID of the created VPC"
  value       = aws_vpc.main.id
}

output "subnet_id" {
  description = "The ID of the created Subnet"
  value       = aws_subnet.main.id
}

output "security_group_id" {
  description = "The ID of the created Security Group"
  value       = aws_security_group.allow_ssh.id
}

output "instance_id" {
  description = "The ID of the deployed EC2 instance"
  value       = aws_instance.web.id
}

output "instance_public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = aws_instance.web.public_ip
}

output "instance_private_ip" {
  description = "The private IP address of the EC2 instance"
  value       = aws_instance.web.private_ip
}
