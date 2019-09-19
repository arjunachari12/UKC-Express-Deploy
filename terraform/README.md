# Deploy UKC Using Terraform

[Terraform](https://www.terraform.io/) is a tool for infrastructure deployment, including deploying servers over AWS. It is used here to rapidly deploy a preconfigured [UKC](https://www.unboundtech.com/docs/CASP/CASP_User_Guide-HTML/Content/Products/CASP/CASP_Offerhttps://www.unboundtech.com/docs/UKC/UKC_User_Guide/HTML/Content/Products/UKC-EKM/UKC_User_Guide/Introduction/EKMterms.html#h2_1) system.

## Getting Started

**Step 1: The AWS Server**
1. Create an AWS account if you do not have one.
2. Pick a Linux-based server that will be used for UKC. It can be one of these platforms:
    - RHEL/CentOS 7.2 and later
	 - Windows 10
	 - Ubuntu 14.04/16.04/18.04
3. The platform must have these minimum requirements:
    - At least 200GB of disk space on the root volume.
    - At least 8GB of system memory.
    - At least 2 CPU cores.
	- Open SSL 1.1 or newer.
	
**Step 2: Install Terraform**
1. Download Terraform for Linux from https://www.terraform.io/downloads.html.
    - You need Terraform 0.12 or newer.
1. Uncompress the archive that you downloaded.

**Step 3: Download the UKC repo**
All of these steps should be executed on your AWS server.
1. Download or clone the UKC repo. 

    It contains these files:
    - UKC_variables.tf - Terraform configuration file.
    - UKC_unbound.tf - Terraform configuration file.
1. Download the UKC package.
    - ekm-2.0.XXX.YYYYY-RHES.x86_64.rpm
    
# Deploy UKC Using Terraform

1. Download *UKC_unbound.tf* and *UKC_variables.tf* files from this repo.

2. Edit *UKC_variables.tf*. Replace every *"!!!!!! replace it with ......... !!!!!!"* string by the relevant value.

## Launch UKC
1. Start Terraform.
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

## Terminate UKC
Use this command to terminate UKC.
   ```
   $ terraform destroy -auto-approve --var "provide_ssh=true"
   ```

`--var "provide_ssh=true"` can be set to *false*. In this case, SSH private keys for access to UKC Partner and Aux will only be uploaded to the bastion host. If the parameter is not be used in command line, the user will be prompted to input the value.
