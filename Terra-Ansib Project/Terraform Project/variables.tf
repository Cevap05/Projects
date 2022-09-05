variable "my_vpc_name" {
    type = object({
        Name = string
    })
}

variable "my_subnet_name" {
    type = object({
        Name = string
    })
}

variable "my_instance_type" {
    type = string
    default = "t2.micro"
}

variable "my_instance_count" {
    type = number
}

variable "my_ami" {
    type = string
}

variable "ansible_master" {
    type = object({
        Name = string
    })
}

variable "ansible_slave_names" {
    type = list
    default = ["Ansible Slave 1", "Ansible Slave 2", "Ansible Slave 3"]
}

variable "ansible_slave_ips" {
    type = list
    default = ["10.0.1.20", "10.0.1.30", "10.0.1.40"]
}

variable "my_s3_bucket" {
    type = object({
        Name = string
    })
}