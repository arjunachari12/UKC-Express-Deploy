#
# unbound.tf -- Create stand-alone Unbound infrastructure from VPC
#

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"

  region = "${var.aws_region}"
}

data "aws_availability_zones" "available" {}

data "aws_ami" "ubuntu" {
  owners      = ["099720109477"]
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

resource "aws_key_pair" "auth_ep" {
  key_name   = "${var.key_name_0}"
  public_key = "${file(var.ep_public_key_path)}"
}

resource "aws_key_pair" "auth_partner_aux" {
  key_name   = "${var.key_name_1}"
  public_key = "${file(var.partner_public_key_path)}"
}

resource "aws_vpc" "unbound" {
  cidr_block           = "10.138.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.resource-group-name}: VPC"
  }
}

locals {
  domain = "${var.resource-group-name}.unboundtech.local"
}

resource "aws_route53_zone" "unbound" {
  name = "${local.domain}"

  vpc {
    vpc_id = "${aws_vpc.unbound.id}"
  }

  tags = {
    Name = "${var.resource-group-name}: Route 53 zone"
  }
}

resource "aws_vpc_dhcp_options" "unbound" {
  domain_name         = "${local.domain}"
  domain_name_servers = ["AmazonProvidedDNS"]

  tags = {
    Name = "${var.resource-group-name}: DHCP"
  }
}

resource "aws_vpc_dhcp_options_association" "unbound" {
  vpc_id          = "${aws_vpc.unbound.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.unbound.id}"
}

resource "aws_subnet" "public" {
  vpc_id                  = "${aws_vpc.unbound.id}"
  cidr_block              = "10.138.0.0/24"
  map_public_ip_on_launch = true

  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  tags = {
    Name = "${var.resource-group-name}: Public subnet 0"
  }
}

resource "aws_subnet" "private1" {
  vpc_id                  = "${aws_vpc.unbound.id}"
  cidr_block              = "10.138.1.0/24"
  map_public_ip_on_launch = true

  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  depends_on = ["aws_route53_zone.unbound"]

  tags = {
    Name = "${var.resource-group-name}: Private subnet 1"
  }
}

resource "aws_internet_gateway" "public" {
  vpc_id = "${aws_vpc.unbound.id}"

  tags = {
    Name = "${var.resource-group-name}: Public gateway"
  }
}

resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.unbound.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.public.id}"
}

resource "aws_security_group" "word-ukc" {
  name        = "WORD-UKC"
  description = "Security group beetwen word and EP"
  vpc_id      = "${aws_vpc.unbound.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 6603
    to_port     = 6603
    protocol    = "tcp"
    cidr_blocks = ["10.138.0.0/16"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.resource-group-name}: Security group beetwen word and EP"
  }
}

resource "aws_security_group" "ukc-ukc" {
  name        = "UKC-UKC"
  description = "Security group beetwen EP, Partner and AUX"
  vpc_id      = "${aws_vpc.unbound.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.138.0.0/16"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.138.0.0/16"]
  }

  ingress {
    from_port   = 6603
    to_port     = 6603
    protocol    = "tcp"
    cidr_blocks = ["10.138.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.resource-group-name}: Security group beetwen EP, Partner and AUX"
  }
}

#########################################
# Install UKC
#########################################
resource "null_resource" "install_ukc_on_aux" {
  connection {
    bastion_host = "${aws_instance.ep.public_ip}"
    bastion_user = "${var.os_user_0}"
    bastion_private_key = "${file(var.ep_private_key_path)}"
    host         = "${aws_instance.aux.private_ip}"
    type         = "ssh"
    user         = "${var.os_user_0}"
    private_key  = "${file(var.partner_private_key_path)}"
  }

  depends_on = [
    "null_resource.install_java_aux",
  ]

  provisioner file {
    source      = "${var.ukc_pac}"
    destination = "/home/${var.os_user_0}/ukc.deb"
  }

  provisioner "remote-exec" {
    inline = [
      "echo + sudo dpkg -i /home/${var.os_user_0}/ukc.deb",
      "sudo dpkg -i /home/${var.os_user_0}/ukc.deb",
    ]
  }
}

resource "null_resource" "install_ukc_on_partner" {
  connection {
    bastion_host = "${aws_instance.ep.public_ip}"
    bastion_user = "${var.os_user_0}"
    bastion_private_key = "${file(var.ep_private_key_path)}"
    host         = "${aws_instance.partner.private_ip}"
    type         = "ssh"
    user         = "${var.os_user_0}"
    private_key  = "${file(var.partner_private_key_path)}"
  }

  depends_on = [
    "null_resource.install_java_partner",
  ]

  provisioner file {
    source      = "${var.ukc_pac}"
    destination = "/home/${var.os_user_0}/ukc.deb"
  }

  provisioner "remote-exec" {
    inline = [
      "echo + sudo dpkg -i /home/${var.os_user_0}/ukc.deb",
      "sudo dpkg -i /home/${var.os_user_0}/ukc.deb",
    ]
  }
}

resource "null_resource" "install_ukc_on_ep" {
  connection {
    host         = "${aws_instance.ep.public_ip}"
    type         = "ssh"
    user         = "${var.os_user_0}"
    private_key  = "${file(var.ep_private_key_path)}"
  }

  depends_on = [
    "null_resource.install_java_ep",
  ]

  provisioner file {
    source      = "${var.ukc_pac}"
    destination = "/home/${var.os_user_0}/ukc.deb"
  }

  provisioner "remote-exec" {
    inline = [
      "echo + sudo dpkg -i /home/${var.os_user_0}/ukc.deb",
      "sudo dpkg -i /home/${var.os_user_0}/ukc.deb",
    ]
  }
}


#########################################
# Install Java
#########################################
resource "null_resource" "install_java_aux" {
  connection {
    bastion_host = "${aws_instance.ep.public_ip}"
    bastion_user = "${var.os_user_0}"
    bastion_private_key = "${file(var.ep_private_key_path)}"
    host         = "${aws_instance.aux.private_ip}"
    type         = "ssh"
    user         = "${var.os_user_0}"
    private_key  = "${file(var.partner_private_key_path)}"
  }

  depends_on = [
    "aws_instance.ep",
    "aws_route53_record.ep",
    "aws_instance.aux",
    "aws_route53_record.aux",
  ]

  provisioner "remote-exec" {
    inline = [
      "echo + sudo apt-get update",
      "sudo apt-get update",
      "echo + sudo apt-get -y install default-jre",
      "sudo apt-get -y install default-jre",
    ]
  }
}

resource "null_resource" "install_java_partner" {
  connection {
    bastion_host = "${aws_instance.ep.public_ip}"
    bastion_user = "${var.os_user_0}"
    bastion_private_key = "${file(var.ep_private_key_path)}"
    host         = "${aws_instance.partner.private_ip}"
    type         = "ssh"
    user         = "${var.os_user_0}"
    private_key  = "${file(var.partner_private_key_path)}"
  }

  depends_on = [
    "aws_instance.ep",
    "aws_route53_record.ep",
    "aws_instance.partner",
    "aws_route53_record.partner",
  ]

  provisioner "remote-exec" {
    inline = [
      "echo + sudo apt-get update",
      "sudo apt-get update",
      "echo + sudo apt-get -y install default-jre",
      "sudo apt-get -y install default-jre",
    ]
  }
}

resource "null_resource" "install_java_ep" {
  connection {
    host         = "${aws_instance.ep.public_ip}"
    type         = "ssh"
    user         = "${var.os_user_0}"
    private_key  = "${file(var.ep_private_key_path)}"
  }

  depends_on = [
    "aws_instance.ep",
    "aws_route53_record.ep",
  ]

  provisioner "remote-exec" {
    inline = [
      "echo + sudo apt-get update",
      "sudo apt-get update",
      "echo + sudo apt-get -y install default-jre",
      "sudo apt-get -y install default-jre",
    ]
  }
}

#########################################
# EP / bastion
#########################################
resource "aws_instance" "ep" {
  connection {
    host = coalesce(self.public_ip, self.private_ip)
    type = "ssh"
    user = "${var.os_user_0}"
    private_key = "${file(var.ep_private_key_path)}"
  }

  ami           = data.aws_ami.ubuntu.id
  instance_type = "${var.instance_type_ukc}"

  key_name               = "${aws_key_pair.auth_ep.id}"
  subnet_id              = "${aws_subnet.public.id}"
  vpc_security_group_ids = ["${aws_security_group.word-ukc.id}"]

  tags = {
    Name = "${var.resource-group-name}: UKC EP / Bastion"
  }
}

#########################################
# Copy ssh keys to bastion
# if "provide_ssh" defined
# $ terraform plan -var="provide_ssh=true"
#########################################
resource "null_resource" "copy_id_rsa_to_bastion" {
  connection {
    host         = "${aws_instance.ep.public_ip}"
    type         = "ssh"
    user         = "${var.os_user_0}"
    private_key  = "${file(var.ep_private_key_path)}"
  }

  depends_on = ["null_resource.ekm_partitions_ep"]

  count = "${var.provide_ssh ? 1 : 0}"

  provisioner file {
    source      = "${var.ep_private_key_path}"
    destination = "/home/${var.os_user_0}/.ssh/id_rsa"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 600 /home/${var.os_user_0}/.ssh/id_rsa",
    ]
  }

}

#########################################
# UKC bootstrup
#########################################
resource "null_resource" "ekm_boot_partner" {
  connection {
    bastion_host = "${aws_instance.ep.public_ip}"
    bastion_user = "${var.os_user_0}"
    bastion_private_key = "${file(var.ep_private_key_path)}"
    host         = "${aws_instance.partner.private_ip}"
    type         = "ssh"
    user         = "${var.os_user_0}"
    private_key  = "${file(var.partner_private_key_path)}"
  }

  depends_on = [
    "null_resource.install_ukc_on_ep",
    "null_resource.install_ukc_on_partner",
  ]

  provisioner "remote-exec" {
    inline = [
      "echo + sudo /opt/ekm/bin/ekm_boot_partner.sh -s partner -p ep -f",
      "sudo /opt/ekm/bin/ekm_boot_partner.sh -s partner -p ep -f",
      "echo + sleep 20",
      "sleep 20",
      "echo + sudo su - -c 'nohup service ekm start &'",
      "sudo su - -c 'nohup service ekm start &'",
      "echo \"+ ps -ef | grep tomcat\"",
      "ps -ef | grep tomcat",
      "echo + sleep 20",
      "sleep 20",
      "echo \"+ ps -ef | grep tomcat\"",
      "ps -ef | grep tomcat",
    ]
  }
}

resource "null_resource" "ekm_boot_ep" {
  connection {
    host         = "${aws_instance.ep.public_ip}"
    type         = "ssh"
    user         = "${var.os_user_0}"
    private_key  = "${file(var.ep_private_key_path)}"
  }

  depends_on = [
    "null_resource.install_ukc_on_ep",
    "null_resource.install_ukc_on_partner",
  ]

  provisioner "remote-exec" {
    inline = [
      "echo + sudo /opt/ekm/bin/ekm_boot_ep.sh -s ep -p partner -w ${var.password1} -f",
      "sudo /opt/ekm/bin/ekm_boot_ep.sh -s ep -p partner -w ${var.password1} -f",
      "echo + sleep 20",
      "sleep 20",
      "echo + sudo su - -c 'nohup service ekm start &'",
      "sudo su - -c 'nohup service ekm start &'",
      "echo + sleep 20",
      "sleep 20",
    ]
  }
}


#########################################
# Restart UKC service
#########################################
resource "null_resource" "ekm_service_partner" {
  connection {
    bastion_host 	= "${aws_instance.ep.public_ip}"
    bastion_user 	= "${var.os_user_0}"
    bastion_private_key = "${file(var.ep_private_key_path)}"
    host         	= "${aws_instance.partner.private_ip}"
    type         	= "ssh"
    user         	= "${var.os_user_0}"
    private_key  	= "${file(var.partner_private_key_path)}"
  }

  depends_on = ["null_resource.ekm_boot_ep","null_resource.ekm_boot_partner"]

  provisioner "remote-exec" {
    inline = [
      "echo + sudo su - -c 'nohup service ekm restart &'",
      "sudo su - -c 'nohup service ekm restart &'",
    ]
  }
}

resource "null_resource" "ekm_service_ep" {
  connection {
    host         = "${aws_instance.ep.public_ip}"
    type         = "ssh"
    user         = "${var.os_user_0}"
    private_key  = "${file(var.ep_private_key_path)}"
  }

  depends_on = ["null_resource.ekm_boot_ep","null_resource.ekm_boot_partner"]

  provisioner "remote-exec" {
    inline = [
      "echo + sudo su - -c 'nohup service ekm restart &'",
      "sudo su - -c 'nohup service ekm restart &'",
      "echo + sleep 20; sleep 20",
    ]
  }
}

#########################################
# Add AUX to EKM
#########################################
resource "null_resource" "ekm_add-aux" {
  depends_on = [
    "null_resource.ekm_service_ep",
    "aws_route53_record.aux",
    "null_resource.install_ukc_on_aux",
  ]

  #------------------
  # AUX: bootstrup
  #------------------
  provisioner "remote-exec" {
    connection {
      bastion_host 	= "${aws_instance.ep.public_ip}"
      bastion_user 	= "${var.os_user_0}"
      bastion_private_key = "${file(var.ep_private_key_path)}"
      host         	= "${aws_instance.aux.private_ip}"
      type         	= "ssh"
      user         	= "${var.os_user_0}"
      private_key  	= "${file(var.partner_private_key_path)}"
    }

    inline = [
      "uname -a",
      "echo + sudo /opt/ekm/bin/ekm_boot_additional_server.sh -s aux",
      "sudo /opt/ekm/bin/ekm_boot_additional_server.sh -s aux",
      "echo + sleep 20; sleep 20",
      "echo + sudo su - -c 'nohup service ekm start &'",
      "sudo su - -c 'nohup service ekm start &'",
      "echo + sleep 30; sleep 30",
    ]
  }

  #------------------
  # EP: add aux
  #------------------
  provisioner "remote-exec" {
    connection {
      host         = "${aws_instance.ep.public_ip}"
      type         = "ssh"
      user         = "${var.os_user_0}"
      private_key  = "${file(var.ep_private_key_path)}"
    }

    inline = [
      "uname -a",
      "echo + sudo ucl server create -a aux -w ${var.password1}",
      "yes Y | sudo ucl server create -a aux -w ${var.password1}",
    ]
  }

  #------------------
  # AUX: restart
  #------------------
  provisioner "remote-exec" {
    connection {
      bastion_host 	= "${aws_instance.ep.public_ip}"
      bastion_user 	= "${var.os_user_0}"
      bastion_private_key = "${file(var.ep_private_key_path)}"
      host         	= "${aws_instance.aux.private_ip}"
      type         	= "ssh"
      user         	= "${var.os_user_0}"
      private_key  	= "${file(var.partner_private_key_path)}"
    }

    inline = [
      "uname -a",
      "echo + sudo su - -c 'nohup service ekm restart &'",
      "sudo su - -c 'nohup service ekm restart &'",
      "echo + sleep 20",
      "sleep 20",
    ]
  }
}


#########################################
# UKC partitions creation
#########################################
resource "null_resource" "ekm_partitions_ep" {
  connection {
    host         = "${aws_instance.ep.public_ip}"
    type         = "ssh"
    user         = "${var.os_user_0}"
    private_key  = "${file(var.ep_private_key_path)}"
  }

  depends_on = ["null_resource.ekm_service_ep","null_resource.ekm_service_partner","null_resource.ekm_add-aux"]

  provisioner "remote-exec" {
    inline = [
      "echo + ucl server test",
      "ucl server test",
      "echo + sudo ucl partition create -p partition1 -w ${var.password1} -s ${var.password1}",
      "sudo ucl partition create -p partition1 -w ${var.password1} -s ${var.password1}",
      "echo + sudo ucl user reset-pwd -p partition1 -n user -w ${var.password1} -d ${var.password1}",
      "sudo ucl user reset-pwd -p partition1 -n user -w ${var.password1} -d ${var.password1}",
      "echo + sudo ucl system-settings set -k no-cert -v 1 -w ${var.password1}",
      "sudo ucl system-settings set -k no-cert -v 1 -w ${var.password1}",
    ]
  }
}


resource "aws_route53_record" "ep" {
  zone_id = "${aws_route53_zone.unbound.zone_id}"
  name    = "ep"
  type    = "A"
  ttl     = "5"
  records = ["${aws_instance.ep.private_ip}"]
}

resource "aws_instance" "partner" {
  connection {
    bastion_host 	= "${aws_instance.ep.public_ip}"
    bastion_user 	= "${var.os_user_0}"
    bastion_private_key = "${file(var.ep_private_key_path)}"
    host		= coalesce(self.public_ip, self.private_ip)
    type         	= "ssh"
    user         	= "${var.os_user_0}"
    private_key  	= "${file(var.partner_private_key_path)}"
  }


  ami           = data.aws_ami.ubuntu.id
  instance_type = "${var.instance_type_ukc}"

  key_name               = "${aws_key_pair.auth_partner_aux.id}"
  subnet_id              = "${aws_subnet.private1.id}"
  vpc_security_group_ids = ["${aws_security_group.ukc-ukc.id}"]

  tags = {
    Name = "${var.resource-group-name}: Partner UKC"
  }

  depends_on = ["aws_instance.ep"]
}

resource "aws_route53_record" "partner" {
  zone_id = "${aws_route53_zone.unbound.zone_id}"
  name    = "partner"
  type    = "A"
  ttl     = "5"
  records = ["${aws_instance.partner.private_ip}"]
}

resource "aws_instance" "aux" {
  connection {
    bastion_host 	= "${aws_instance.ep.public_ip}"
    bastion_user 	= "${var.os_user_0}"
    bastion_private_key = "${file(var.ep_private_key_path)}"
    host		= coalesce(self.public_ip, self.private_ip)
    type         	= "ssh"
    user         	= "${var.os_user_0}"
    private_key  	= "${file(var.partner_private_key_path)}"
  }

  ami           = data.aws_ami.ubuntu.id
  instance_type = "${var.instance_type_ukc}"

  key_name               = "${aws_key_pair.auth_partner_aux.id}"
  subnet_id              = "${aws_subnet.private1.id}"
  vpc_security_group_ids = ["${aws_security_group.ukc-ukc.id}"]

  tags = {
    Name = "${var.resource-group-name}: Aux UKC"
  }

  depends_on = ["aws_instance.ep"]
}

resource "aws_route53_record" "aux" {
  zone_id = "${aws_route53_zone.unbound.zone_id}"
  name    = "aux"
  type    = "A"
  ttl     = "5"
  records = ["${aws_instance.aux.private_ip}"]
}
