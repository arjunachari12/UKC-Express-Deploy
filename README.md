# UKC Express Deploy

Unbound Key Control (“**UKC**”) provides the advanced technology and the architecture for secure key management. An overview of the UKC solution is found [here](https://www.unboundtech.com/product/unbound-key-control/).

UKC can be rapidly deployed using one of these methods:
- [Docker](https://hub.docker.com/?overlay=onboarding) - Install UKC in a container. This method is intended for POCs.
- [Terraform](https://www.terraform.io/downloads.html) - Use code to build the UKC infrastructure. This method is intended for production systems.

The rapid installation process is described below. For the full installation process, refer to the [UKC User Guide](https://www.unboundtech.com/docs/UKC/UKC_User_Guide/HTML/Content/Products/UKC-EKM/UKC_User_Guide/Installation/A1.html).

## Overview

The UKC implementation is comprised of the following components:

1. **UKC Entry Point Server**
2. **UKC Partner Server**
3. **UKC Auxiliary Server**

Both deployment options install all of the above components. After installation, you can log into the UKC web interface and start using UKC!

<a name="General-Prerequsites"></a>
## General Prerequsites
The following are required before installing UKC. 
1. An Infura access token (only needed for Ethereum ledger access). See [Infura](https://infura.io/register).
   - Register for the Infura site.
   - Create a new project.
   - Copy the access token from the project page.
1. BlockCypher access token (only needed for Bitcoin ledger access). See [BlockCypher](https://accounts.blockcypher.com/signup).
   - Register for the Blockcypher site.
   - After verifying your email, it opens a page that displays the token.
1. Firebase messaging token (to enable push notifications). Contact Unbound ([support@unboundtech.com](mailto:support@unboundtech.com)) for it.
    - For express deploy using Docker, you must contact Unbound ([support@unboundtech.com](mailto:support@unboundtech.com)) to get access to the Docker images, even if you are not going to use a Firebase token (such as if you are not going to use push notifications). 

## Installation
After completing the prerequisites, follow the instructions based on the installation type:
- [Docker](./ukc-docker)
- [Terraform](./ukc-terraform)
