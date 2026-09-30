# الموارد الرئيسية المطلوبة
terraform {}

provider "aws" {
  region = "us-east-1"
}

# 1. البحث عن أحدث صورة Ubuntu تلقائياً
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# 2. الجدار الناري (Security Group)
resource "aws_security_group" "my_web_sg" {
  name        = "realworld-web-sg"
  description = "Allow SSH, HTTP, and HTTPS"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9090
    to_port     = 9090
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

# 3. مفتاح الـ SSH
resource "aws_key_pair" "deployer" {
  key_name   = "my-vps-key"
  public_key = file(var.ssh_public_key_path)
}

# 4. الخادم (EC2 Instance)
resource "aws_instance" "my_first_ec2" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.my_web_sg.id]
  key_name               = aws_key_pair.deployer.key_name

  root_block_device {
    volume_size           = 20
    volume_type           = "gp3"
    delete_on_termination = true
  }

  tags = {
    Name = "RealWorld-VPS"
  }
}