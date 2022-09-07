# This is the "terraform.tvars" file. It sends the input to the corresponding "variables.tf" file.
my_vpc_name = {
  Name = "Ademir's VPC"
}

my_public_subnet_name = {
  Name = "Ademir's Public Subnet"
}

my_private_subnet_name = {
  Name = "Ademir's Private Subnet"
}

# Optional as default t2.micro was deteremined in the variable itself.
my_instance_type = "t2.micro"

my_instance_count = 3

my_ami = "ami-02358d9f5245918a3"

ansible_master = {
  Name = "Ansible Master"
}

my_s3_bucket = {
  Name = "ademirs-s3-bucket-project"
}