# 1. AWS Provider Configuration
provider "aws" {
  region = "us-east-1"
}

# 2. Network Infrastructure (VPC & Internet Gateway)
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = { Name = "Ticket-App-VPC" }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "Ticket-App-IGW" }
}

# 3. Subnet & Routing
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags                    = { Name = "Ticket-App-Public-Subnet" }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = { Name = "Ticket-App-RouteTable" }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# 4. Security Group (Full Stack Access)
resource "aws_security_group" "ticket_sg" {
  name        = "Ticket-app-sg"
  description = "Allow SSH, Jenkins, Docker, Minikube, and Web Traffic"
  vpc_id      = aws_vpc.main.id

  # SSH for Management
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP & HTTPS
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Jenkins (8080) & Socat Bridge/App (8081)
  ingress {
    from_port   = 8080
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Docker Compose (8082)
  ingress {
    from_port   = 8082
    to_port     = 8082
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Minikube NodePort (30007)
  ingress {
    from_port   = 30007
    to_port     = 30007
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound Traffic (Allow all)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "Ticket-App-SG" }
}

# 5. EC2 Instance
resource "aws_instance" "devops_node" {
  ami                    = "ami-04b70fa74e45c3917" # Ubuntu 24.04 LTS
  instance_type          = "t3.medium"
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.ticket_sg.id]
  key_name               = "ticket-key" 

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  tags = {
    Name = "DevOps-Assessment-Node"
  }
}

# 6. Output Public IP
output "instance_ip" {
  value       = aws_instance.devops_node.public_ip
  description = "New Public IP to SSH into your server"
}