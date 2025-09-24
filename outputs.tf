output "public_ip" {
  value = aws_instance.app_instance.public_ip
}

output "public_dns" {
  value = aws_instance.app_instance.public_dns
}
