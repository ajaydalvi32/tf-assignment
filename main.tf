provider "aws" {
  region = var.region
}

# Security group
resource "aws_security_group" "app_sg" {
  name        = "app-sg"
  description = "Allow SSH, Flask and Express ports"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Get latest Ubuntu 22.04 LTS AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# EC2 instance
resource "aws_instance" "app_instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = var.key_name
  security_groups = [aws_security_group.app_sg.name]

  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install -y python3 python3-pip nodejs npm git

              # Flask app
              mkdir -p /home/ubuntu/flask-app
              cat > /home/ubuntu/flask-app/app.py << APP
from flask import Flask
app = Flask(__name__)
@app.route('/')
def hello():
    return 'Hello from Flask!'
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
APP
              nohup python3 /home/ubuntu/flask-app/app.py &

              # Express app
              mkdir -p /home/ubuntu/express-app
              cd /home/ubuntu/express-app
              npm init -y
              npm install express
              cat > index.js << EXPRESS
const express = require('express');
const app = express();
app.get('/', (req,res) => res.send('Hello from Express!'));
app.listen(3000, () => console.log('Express running on port 3000'));
EXPRESS
              nohup node index.js &
              EOF

  tags = {
    Name = "Flask-Express-App"
  }
}
