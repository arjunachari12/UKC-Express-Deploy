# 1. Deploy UKC Using Docker

This project provides a quick and easy way to evaluate the Unbound Key Control [UKC](https://www.unboundtech.com/product/unbound-key-control/) solution. UKC is composed of several components that need to be setup to work properly. Therefore, this quick start solution is provided to enable you to launch UKC without any configuration using Docker.

**Note: This project is intended to be used for POCs.**

This implementation is only for demo proposes. For production, you can [Deploy UKC Using Terraform](../ukc-terraform/README.md).

## 1.1. Getting Started

1. Contact Unbound ([support@unboundtech.com](mailto:support@unboundtech.com)) to get access to the Docker images.
1. Install Docker.
    - For Windows:
        - Install Docker Desktop CE (community edition). It must include Docker Engine version 19.03 or newer. You can get the latest version from [Docker](https://hub.docker.com/?overlay=onboarding).
        - Use the default Docker settings during installation.
        - If you are not registered for Docker, follow the [registration process](https://hub.docker.com/?overlay=onboarding).
        - Download the Docker Desktop installer and install it.
        - Enable Hyper-V using the [instructions from Microsoft](https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/quick-start/enable-hyper-v).
        - You must [enable virtualization](https://blogs.technet.microsoft.com/canitpro/2015/09/08/step-by-step-enabling-hyper-v-for-use-on-windows-10/) in the BIOS on your device.
   - For Linux:
        - If you are not registered for Docker, follow the [registration process](https://hub.docker.com/?overlay=onboarding).
        - Follow the instructions to [install Docker Compose](https://docs.docker.com/compose/install/).

       
1. [Request](mailto:support@unboundtech.com) to be added to Unbound's Docker organization.
1. Download or clone this repository from the [main page](https://github.com/unbound-tech/UKC-Express-Deploy) or click [here](https://github.com/unbound-tech/UKC-Express-Deploy/archive/master.zip).
1. The downloaded repository file should be uncompressed and placed on the device where you will run Docker. The download contains a folder called *ukc-docker*. You must run the Docker commands from this folder.
1. For Windows, start Docker on your device.

   You can check if Docker is running with the command `docker info`. If it returns an error, then it is not running. Otherwise, it returns status information about the Docker installation.
1. Open a terminal and navigate to the `ukc-docker` folder.
1. Run this command to log into Docker:
    ```bash
	docker login
	```
	Enter the credentials that you created for the Docker Hub website.
1. Run Docker to create the UKC container:
    ```bash
    docker-compose up
    ```
    The setup takes several minutes to complete.
	
	Everything is installed and working when you see this message:
    ```
    UKC system is ready
    ```
    
    Note: Docker takes several minutes to create the UKC system. If it hangs for too long, use `Ctrl-c` to stop the process and then run the following commands to restart:
    ```bash
    docker-compose down
    docker-compose up
    ```
1. Open your browser and navigate to `https://localhost/login`. Use these credentials to log in:
    - Username: so
	- Password: Unbound1!

**Congratulations! UKC is now running.**

## 1.2. Explore the Web Interface
The Web UI provides the following screens:

- Keys and Certificates - provides information about your keys and certificates.
- Partitions - lists all partitions.
- Clients - lists all client.
- Users - lists all users.
- Authorize - shows operations that are pending approval.
- Config - shows the UKC settings.
- Rescue - use to reset the SO password.
- Help - open the UKC User Guide.

## 1.3. More Information
This release has these associated documents:

- [UKC User Guide](https://www.unboundtech.com/docs/UKC/UKC_User_Guide/HTML/Content/Products/Unbound_Cover_Page.htm)
    - [UKC Web UI](https://www.unboundtech.com/docs/UKC/UKC_User_Guide/HTML/Content/Products/UKC-EKM/UKC_User_Guide/UI/A1.html) - explore more about the Web UI.


## 1.4. Troubleshooting

### 1.4.1. Cannot open the web console

If you cannot open the UKC web console in your browser, you might have port 443 in use by another service.

You can change UKC web console port by editing `docker-compose.yml`, and replacing the UKC export port with a different port.

For example, to change the port from 443 to 9443: 
1. Change `"443:443"` to `"9443:443"`. 
2. Restart the Docker with:

    ```bash
    docker-compose down
    docker-compose up
    ```
3. Use `https://localhost:9443/login` to open UKC web console.

### 1.4.2. Restarting Docker

To restart Docker:

1. Ensure that the previous session is finished:
    ```bash
    docker-compose down
    ```
2. Get the latest files:
    ```bash
    docker-compose pull
    ```
3. Start Docker:
    ```bash
    docker-compose up
    ```
    
## 1.5. Tips

### 1.5.1. Installing Docker on CentOS 7

The default Docker installed by `yum` is an older version of Docker. You can use the technique below to update to a newer Docker version.

```bash
sudo yum install -y yum-utils   device-mapper-persistent-data   lvm2
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum -y install docker-ce
sudo systemctl start docker
sudo curl -L \
     "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" \
     -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```
