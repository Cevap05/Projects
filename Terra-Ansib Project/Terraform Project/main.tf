# This is a local value, similar to a variable. Used in tags few times.
# You can't pass anything into locals, unlike how you can with variables (using variables.tf &terraform.tfvars).
# The "upper" function will uppercase the word.
locals {
    owner = upper("ademir's")
}


# Here we are using a "Data Source", to pull information from an existing AWS resource.
# In this case, we're calling the default AWS VPC.
# We'll be calling this in the "outputs.tf" file, to output information about the default AWS VPC.
# You can refer to Terraform Doc' about "Argument Reference", to call out specific existing resources.
# For example if I wanted to call on an existing VPC by tag, I would do this:
/*
data "aws_vpc" "default_vpc" {
    filter {
        name = "tag:Name"
        value = ["The-Existing-VPC-Name"]
    }
}
*/
data "aws_vpc" "default_vpc" {
    default = true
}


# Project VPC
resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
    # Here is a variable that takes info from "variabels.tf" & "terraform.tvars".   
    tags = var.my_vpc_name
}


# Project Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  # Example of a local being used, below.
  tags = {
    Name = "${local.owner} IGW"
  }
}


# Project Public Subnet
resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = "true"

    tags = var.my_public_subnet_name
}


# Project Private Subnet
resource "aws_subnet" "private_subnet" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = "false"

    tags = var.my_private_subnet_name
}


# Project Route Table for Public Subnet -> IGW
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${local.owner} Public Route Table"
  }
}


# Project Route Table for Private Subnet -> NAT Gatway
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "${local.owner} Private Route Table"
  }
}


# Elastic IP (EIP) for the NAT Gateway
resource "aws_eip" "nat_eip" {
  vpc      = true
  depends_on = [aws_internet_gateway.igw]
  tags = {
    Name = "Ademir's NAT Gateway EIP"
  }
}


# Creating a NAT Gateway for the Public Subnet (VPC).
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = "Ademir's NAT Gateway"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]  #(Maybe .id)
}


# Project Route Table Association (connecting Public Subnet to RT)
resource "aws_route_table_association" "pub_subnet" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}


# Project Route Table Association (connecting Private Subnet to RT)
resource "aws_route_table_association" "priv_subnet" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}


# Ansible Slave EC2 Instance's (x3)
resource "aws_instance" "Ans_Slaves" {
    count = var.my_instance_count
    ami = var.my_ami
    instance_type = var.my_instance_type
    subnet_id = aws_subnet.private_subnet.id
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
    subnet_id = aws_subnet.public_subnet.id
    #associate_public_ip_address = true     (We'll have the subnet which this EC2 resides, to handle the Public IPs.)
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
    Name = "${local.owner} SG"
  }
}