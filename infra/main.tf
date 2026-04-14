# 1. AWS Provider Configuration
provider "aws" {
  region = "us-east-1"
}

# 2. Variable Definitions (Using your provided IDs)
variable "vpc_id" {
  description = "The ID of the manual VPC"
  default     = "vpc-052dbe1129afa3a93"
}
variable "subnet_id" {
  description = "The ID of the manual Subnet"
  default     = "subnet-01c33215ab5cb0e1f"
}

# 3. Find the Security Group (Assuming you named it 'Ticket-app-sg')
data "aws_security_group" "selected" {
  filter {
    name   = "group-name"
    values = ["Ticket-app-sg"]
  }
  vpc_id = var.vpc_id
}

# 4. Create the EC2 Instance
resource "aws_instance" "devops_node" {
  ami                    = "ami-04b70fa74e45c3917" # Ubuntu 24.04 LTS
  instance_type          = "t3.medium"            # 2 vCPU, 4GB RAM
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [data.aws_security_group.selected.id]
  key_name               = "ticket-key"    # <-- CHANGE THIS to your actual .pem key name (without .pem)

  # Increase storage to 20GB for Jenkins and Docker images
  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  tags = {
    Name = "DevOps-Assessment-Node"
  }
}

# 5. Output the Public IP to your terminal
output "instance_ip" {
  value       = aws_instance.devops_node.public_ip
  description = "Use this IP to SSH into your server"
}