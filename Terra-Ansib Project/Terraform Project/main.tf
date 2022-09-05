# Project VPC
resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
    
    tags = var.my_vpc_name
}

# Project Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Ademir's IGW"
  }
}

# Project Subnet
resource "aws_subnet" "subnet" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"

    tags = var.my_subnet_name
}

# Project Route Table (connecting subnet to IGW)
resource "aws_route_table" "r_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Ademir's Route Table"
  }
}

# Project Route Table Association with Subnet (connecting Subnet to RT)
resource "aws_route_table_association" "rt_subnet" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.r_table.id
}

# Ansible Slave EC2 Instance's (x3)
resource "aws_instance" "Ans_Slaves" {
    count = var.my_instance_count
    ami = var.my_ami
    instance_type = var.my_instance_type
    subnet_id = aws_subnet.subnet.id
    private_ip = element(var.ansible_slave_ips, count.index)
    vpc_security_group_ids = [aws_security_group.SG_SSH_ICMP.id]
    #key_name = "Ademir"

    tags = {
      Name = element(var.ansible_slave_names, count.index)
    }

    user_data = "${file("ans_slave.sh")}"
}

# Ansible Master EC2 Instance
resource "aws_instance" "Ans_Master" {
    ami = var.my_ami
    instance_type = var.my_instance_type
    subnet_id = aws_subnet.subnet.id
    associate_public_ip_address = true
    private_ip = "10.0.1.10"
    # This SG allows the Master Instance to have SSH & ICMP.
    vpc_security_group_ids = [aws_security_group.SG_SSH_ICMP.id]
    # Asks for the following .pem (must have already, not creating new one)
    key_name = "Ademir"

    tags = var.ansible_master

    user_data = "${file("ans_master.sh")}"
}

# Ansible S3 Bucket
resource "aws_s3_bucket" "S3Buck" {
    bucket = "ademirs-project-bucket"

    tags = var.my_s3_bucket
}

# Security Group for EC2 Instances
resource "aws_security_group" "SG_SSH_ICMP" {
  name        = "Allow SSH & ICMP Traffic"
  description = "Allows all SSH and ICMP traffic."
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "Allowing incoming SSH."
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    #ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  ingress {
    description      = "Allowing incoming ICMP."
    from_port        = 0
    to_port          = 0
    protocol         = "all"
    cidr_blocks      = ["0.0.0.0/0"]
    #ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Ademir's SG"
  }
}