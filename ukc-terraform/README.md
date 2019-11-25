# 1. Deploy UKC Using Terraform

[Terraform](https://www.terraform.io/) is a tool for infrastructure deployment, including deploying servers over AWS. It is used here to rapidly deploy a preconfigured [UKC](https://www.unboundtech.com/docs/UKC/UKC_User_Guide/HTML/Content/Products/UKC-EKM/UKC_User_Guide/Introduction/EKMterms.html#h2_1) system.

## 1.1. Installation

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
1. [Contact Unbound](mailto:support@unboundtech.com) to get a link to download the **UKC server package** for RedHat. 
    - The package has the format: ekm-2.0.XXX.YYYYY-RHES.x86_64.rpm

**Step 4: Configure the Terraform files**
1. Locate your *Access Key* and *Secret Access Key* on AWS:
    - Log into your [AWS Management Console](https://console.aws.amazon.com/console).
	- Click on your username at the top right of the page.
	- Click on the **Security Credentials** link from the drop-down menu.
	- Find the *Access Credentials* section, and copy the latest *Access Key ID*.
	- Click on the **Show** link in the same row, and copy the *Secret Access Key*.
1. Edit *UKC_unbound.tf*. In the file, set the *Access Key ID* and *Secret Access Key*.
1. Edit *UKC_variables.tf*. In the file, follow the comments to set all the necessary variables.

**Step 5: Launch Terraform**
1. Start Terraform. This step uses the executable that was downloaded in Step 2. You may need to add it to your path.
   ```
   $ terraform init
   ```
2. Apply the configuration file.
   ```
   $ terraform apply
   ```

**Congratulations! UKC is now running.**

## 1.2. Next Steps
After installation, you can try some of these:
1. [Explore the web interface](./#webint)
1. [Create and activate a client](./#ukcclient)
1. [Integrate UKC with your system](./#integration)

<a name="webint"></a>
### 1.2.1. Explore the Web Interface
Open your browser and navigate to `https://<ip-address>/caspui`, where *<ip-address>* is the EP server. Use these credentials to log in:
- Username: so
- Password: Unbound1!
- Partition: root

The Web UI provides the following screens:

- Keys and Certificates - provides information about your keys and certificates.
- Partitions - lists all partitions.
- Clients - lists all client.
- Users - lists all users.
- Authorize - shows operations that are pending approval.
- Config - shows the UKC settings.
- Rescue - use to reset the SO password.
- Help - open the UKC User Guide.

There is also a partition called **test** that you can use.

For more information on how to use the web interface, see [UKC User Guide](https://www.unboundtech.com/docs/UKC/UKC_User_Guide/HTML/Content/Products/UKC-EKM/UKC_User_Guide/UI/A1.html).

<a name="ukcclient"></a>
### 1.2.2. Create and activate a client

[Contact Unbound](mailto:support@unboundtech.com) to get a link to download the UKC client.

Information about installing the UKC client can be found [here](https://www.unboundtech.com/docs/UKC/UKC_User_Guide/HTML/Content/Products/UKC-EKM/UKC_User_Guide/Installation/ClientInstallation.html#h2_1).

<a name="integration"></a>
### 1.2.3. Integrate UKC with your system

UKC can be integrated with 3rd-party tools, such as databases and web servers. See [here](https://www.unboundtech.com/docs/UKC/UKC_Integration_Guide/HTML/Content/Products/Unbound_Cover_Page.htm) for more information.


## 1.3 Terminating UKC
Use this command to terminate UKC.
   ```
   $ terraform destroy
   ```

