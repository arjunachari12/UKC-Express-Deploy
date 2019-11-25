# UKC Express Deploy

Unbound Key Control (“**UKC**”) provides the advanced technology and the architecture for secure key management. An overview of the UKC solution is found [here](https://www.unboundtech.com/product/unbound-key-control/).

UKC can be rapidly deployed using one of these methods:
- [Docker](https://hub.docker.com/?overlay=onboarding) - Install UKC in a container. This method is intended for POCs.
- [Terraform](https://www.terraform.io/downloads.html) - Use code to build the UKC infrastructure. This method is intended for production systems.

The rapid installation process is described below. For the full installation process, refer to the [UKC User Guide](https://www.unboundtech.com/docs/UKC/UKC_User_Guide/HTML/Content/Products/UKC-EKM/UKC_User_Guide/Installation/A1.html).

Note: If you are trying to use the [CASP Express Deploy](https://github.com/unbound-tech/CASP-Express-Deploy), you cannot run it and the UKC Express Deploy at the same time.

## Overview

The UKC implementation is comprised of the following components:

1. **UKC Entry Point Server**
2. **UKC Partner Server**
3. **UKC Auxiliary Server**

Both deployment options install all of the above components. After installation, you can log into the UKC web interface and start using UKC!

## Installation
To get started with the installation, follow the instructions based on the installation type:
- [Docker](./ukc-docker)
- [Terraform](./ukc-terraform)
