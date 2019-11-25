# Deploy UKC Using Terraform

[Terraform](https://www.terraform.io/) is a tool for infrastructure deployment, including deploying servers over AWS. It is used here to rapidly deploy a preconfigured [UKC](https://www.unboundtech.com/docs/UKC/UKC_User_Guide/HTML/Content/Products/UKC-EKM/UKC_User_Guide/Introduction/EKMterms.html#h2_1) system.

## Installation

**Step 1: The AWS Server**
1. Create an AWS account if you do not have one.
1. Check your AWS permissions that you can create and configure EC2 instances, VPCs, security groups, public IP addresses, and DNS.
	
**Step 2: Download Terraform**
1. Download Terraform for Linux from [here](https://www.terraform.io/downloads.html).
    - You need Terraform 0.12 or newer.
1. Uncompress the archive that you downloaded. It contains the Terraform executable.

**Step 3: Download the UKC repo**

All of these steps should be executed on your AWS server.
1. Download or clone the UKC repo. 

    It contains these files:
    - UKC_variables.tf - Terraform configuration file.
    - UKC_unbound.tf - Terraform configuration file.
1. [Contact Unbound](mailto:support@unboundtech.com) to get a link to download the UKC package. 
    - The package has the format: ekm-2.0.XXX.YYYYY-RHES.x86_64.rpm

**Step 4: Configure the Terraform files**
1. Locate your *Access Key* and *Secret Access Key* on AWS:
    - Log into your [AWS Management Console](https://console.aws.amazon.com/console).
	- Click on your username at the top right of the page.
	- Click on the **Security Credentials** link from the drop-down menu.
	- Find the *Access Credentials* section, and copy the latest *Access Key ID*.
	- Click on the **Show** link in the same row, and copy the *Secret Access Key*.
1. Edit *UKC_unbound.tf*. In the file, set the *Access Key ID* and *Secret Access Key*.
1. Edit *KC_variables.tf*. In the file, set all the following variables:
    - variable "access_key" - *Access Key ID* from AWS.
    - variable "secret_key" - *Secret Access Key* from AWS.
    - variable "resource-group-name" - Name to use in AWS.
    - variable "ep_public_key_path" - Path to the SSH key public part.
    - variable "ep_private_key_path" - Path to the SSH key private part.
    - variable "partner_public_key_path" - Path to the SSH key public part.
    - variable "partner_private_key_path" - Path to the SSH key private part.
    - variable "key_name_0" - Key name for EP key in the key file.
    - variable "key_name_1" - Key name for Partner key in the key file.
    - variable "password1" - Initial password for the UKC.
    - variable "aws_region" - Region for the AWS server.
    - variable "ukc_pac" - The UKC package name downloaded in Step 3.
    - variable "os_user_0" -  EP server user name.

**Step 5: Launch Terraform**
1. Start Terraform. This step uses the executable that was downloaded in Step 2. You may need to add it to your path.
   ```
   $ terraform init
   ```
2. Do something.
   ```
   $ terraform apply demo.plan -no-color | tee demo.apply.out 2>&1
   ```
3. Do something else.
   ```
   $ terraform plan -out=demo.plan -no-color --var "provide_ssh=true" | tee demo.plan.out
   ```

## Terminating UKC
Use this command to terminate UKC.
   ```
   $ terraform destroy -auto-approve --var "provide_ssh=true"
   ```

`--var "provide_ssh=true"` can be set to *false*. In this case, SSH private keys for access to UKC Partner and Aux will only be uploaded to the bastion host. If the parameter is not be used in command line, the user will be prompted to input the value.
