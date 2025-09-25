output "flask_public_ip" {
  value = aws_instance.flask.public_ip
}

output "express_public_ip" {
  value = aws_instance.express.public_ip
}
