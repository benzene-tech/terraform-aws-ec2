output "id" {
  description = "Instance ID"
  value       = aws_instance.this.id
}

output "public_dns" {
  description = "Public dns of instance"
  value       = aws_instance.this.public_dns
}

output "public_ip" {
  description = "Public IP of instance"
  value       = aws_instance.this.public_ip
}

output "security_group" {
  description = "Instance's security group ID"
  value       = aws_security_group.this.id
}
