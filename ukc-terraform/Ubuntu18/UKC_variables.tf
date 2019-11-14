variable "access_key" { default = "<Access Key>" }
variable "secret_key" { default = "<Secret Key>" }
variable "resource-group-name" { default = "Terraform-UKC-demo"}
variable "ep_public_key_path" { default = "/home/<your user>/.ssh/<public key>" }
variable "ep_private_key_path" { default = "/home/<your user>/.ssh/<private key>" }
variable "partner_public_key_path" { default = "/home/<your user>/.ssh/<public key>" }
variable "partner_private_key_path" { default = "/home/<your user>/.ssh/<private key>" }
variable "key_name_0" { default = "Terraform-UKC-EP-key" }
variable "key_name_1" { default = "Terraform-UKC-Partner-AUX-key" }
variable "password1" { default = "Password1!" }
variable "aws_region" { default = "<AWS region>" }
variable "ukc_pac" { default = "ekm-<UKC version>.deb" }
variable "os_user_0" { default = "ubuntu" }
variable "instance_type_ukc" { default = "<AWS instance type>" }


variable "provide_ssh" {
  description = "If true, id_rsa key will be copied to bastion and hosts in the private subnet will be accessible by 2 hops"
}
