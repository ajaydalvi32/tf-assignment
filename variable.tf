variable "vpc_cidr" { default = "10.0.0.0/16" }
variable "public_subnet_cidr1" { default = "10.0.1.0/24" }
variable "public_subnet_cidr2" { default = "10.0.2.0/24" }

variable "backend_ecr_name" { default = "flask-backend" }
variable "frontend_ecr_name" { default = "express-frontend" }

variable "ecs_cluster_name" { default = "my-ecs-cluster" }
