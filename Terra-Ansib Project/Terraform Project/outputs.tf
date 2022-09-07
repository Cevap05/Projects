# These are outputs. You can use "attributes" from the Terraform documentation, to have information returned to you that you are looking for.
# For example, we'll be returning the public IP of the Ansible Master EC2 Instance which will have a public IP assigned.

output "Master_EC2_Public_IP" {
    description = "This is an optional description you can add."
    value = aws_instance.Ans_Master.public_ip
}

output "Slave_EC2_Private_IPs" {
    value = aws_instance.Ans_Slaves[*].private_ip
}

output "my_name" {
    value = "Ademir"
}

# Here, we are outputting the info of the default AWS VPC, from "main.tf".
output "Default_AWS_VPC_INFO" {
    value = data.aws_vpc.default_vpc
}