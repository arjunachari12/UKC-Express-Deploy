variable "access_key" { default = "!!!!!! replace it with access_key !!!!!!" }
variable "secret_key" { default = "!!!!!! replace it with secret key !!!!!!" }
variable "resource-group-name" { default = "Terraform-UKC-demo"}
variable "ep_public_key_path" { default = "/home/!!!!!! replace it with your user !!!!!!/.ssh/!!!!!! replace it with public key !!!!!!" }
variable "ep_private_key_path" { default = "/home/!!!!!! replace it with your user !!!!!!/.ssh/!!!!!! replace it with public key !!!!!!" }
variable "partner_public_key_path" { default = "/home/!!!!!! replace it with your user  !!!!!!/.ssh/!!!!!! replace it with public key!!!!!!" }
variable "partner_private_key_path" { default = "/home/!!!!!! replace it with your user  !!!!!!/.ssh/!!!!!! replace it with public key !!!!!!" }
variable "key_name_0" { default = "Terraform-UKC-EP-key" }
variable "key_name_1" { default = "Terraform-UKC-Partner-AUX-key" }
variable "password1" { default = "Password1!" }
variable "aws_region" { default = "sa-east-1" }
variable "ukc_rpm" { default = "ekm-2.0.1905.36686-RHES.x86_64.rpm" }
variable "os_user_0" {default = "centos" }


variable "provide_ssh" {
  description = "If true, id_rsa key will be copied to bastion and hosts in the private subnet will be accessible by 2 hops"
}
