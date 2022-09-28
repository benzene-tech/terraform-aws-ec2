output "instance_dns" {
  value = aws_instance.this.public_dns
}

output "alb_dns" {
  value = aws_lb.this.dns_name
}
