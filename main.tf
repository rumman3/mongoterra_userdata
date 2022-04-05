provider "aws" {
  region = var.region_var
}

resource "aws_vpc" "devops106_terraform_rumman_vpc_tf" {
  cidr_block = "10.209.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "devops106_terraform_rumman_vpc"
  }
}

##Subnet for the application
resource "aws_subnet" "devops106_terraform_rumman_subnet_webserver_tf" {
  vpc_id = local.vpc_id_var
  cidr_block = "10.209.101.0/24"
  tags = {
    Name = "devops106_terraform_rumman_subnet_webserver"
  }
}

## subnet for the database
resource "aws_subnet" "devops106_terraform_rumman_subnet_mongodb_tf" {
  vpc_id = local.vpc_id_var
  cidr_block = "10.209.202.0/24"
  tags = {
    Name = "devops106_terraform_rumman_subnet_mongodb"
  }
}

## route table for web app and mongodb
resource "aws_route_table" "devops106_terraform_rumman_rt_public_tf" {
  vpc_id = local.vpc_id_var

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.devops106_terraform_rumman_igw_tf.id
  }
}

## route table associations
resource "aws_route_table_association" "devops106_terraform_rumman_assoc_rt_public_subnet101_tf" {
  subnet_id = local.subnet_webserver_id_var
  route_table_id = local.route_table_id_var
}
resource "aws_route_table_association" "devops106_terraform_rumman_assoc_rt_public_subnet202_tf" {
  subnet_id = local.subnet_mongo_id_var
  route_table_id = local.route_table_id_var
}

### internet gateway covers both subnets in vpc
resource "aws_internet_gateway" "devops106_terraform_rumman_igw_tf" {
  vpc_id = local.vpc_id_var
  tags = {
    "Name" = "devops106_terraform_rumman_igw"
  }
}



#################################################################################################################



## Nacl for app - needs to allow any http/s or ssh ingress and mongodb egress
resource "aws_network_acl" "devops106_terraform_rumman_nacl_public_tf" {
  vpc_id = local.vpc_id_var
  subnet_ids = [local.subnet_webserver_id_var]
 ingress {
    rule_no = 100
    from_port = 22
    to_port = 22
    cidr_block = "0.0.0.0/0"
    protocol = "tcp"
    action = "allow"
  }

  ingress {
    rule_no = 200
    from_port = 8080
    to_port = 8080
    cidr_block = "0.0.0.0/0"
    protocol = "tcp"
    action = "allow"
  }

  ingress {
    rule_no = 10000
    from_port = 1024
    to_port = 65535
    cidr_block = "0.0.0.0/0"
    protocol = "tcp"
    action = "allow"
  }


  egress {
    rule_no = 100
    from_port = 80
    to_port = 80
    cidr_block = "0.0.0.0/0"
    protocol = "tcp"
    action = "allow"
  }

  egress {
    rule_no = 200
    from_port = 443
    to_port = 443
    cidr_block = "0.0.0.0/0"
    protocol = "tcp"
    action = "allow"
  }

  egress {
    rule_no = 10000
    from_port = 1024
    to_port = 65535
    cidr_block = "0.0.0.0/0"
    protocol = "tcp"
    action = "allow"
  }

  tags = {
    Name = "devops106_terraform_rumman_nacl_public"
  }
}


# Nacl for database
resource "aws_network_acl" "devops106_terraform_rumman_nacl_mongodb_tf" {
  vpc_id = local.vpc_id_var
  subnet_ids = [local.subnet_mongo_id_var]

   ingress {
    rule_no = 100
    from_port = 22
    to_port = 22
    cidr_block = "0.0.0.0/0"
    protocol = "tcp"
    action = "allow"
  }

  ingress {
    rule_no = 200
    from_port = 27017
    to_port = 27017
    cidr_block = "0.0.0.0/0"
    protocol = "tcp"
    action = "allow"
  }

  ingress {
    rule_no = 10000
    from_port = 1024
    to_port = 65535
    cidr_block = "0.0.0.0/0"
    protocol = "tcp"
    action = "allow"
  }


  egress {
    rule_no = 100
    from_port = 80
    to_port = 80
    cidr_block = "0.0.0.0/0"
    protocol = "tcp"
    action = "allow"
  }

  egress {
    rule_no = 200
    from_port = 443
    to_port = 443
    cidr_block = "0.0.0.0/0"
    protocol = "tcp"
    action = "allow"
  }

  egress {
    rule_no = 10000
    from_port = 1024
    to_port = 65535
    cidr_block = "0.0.0.0/0"
    protocol = "tcp"
    action = "allow"
  }

  tags = {
    Name = "devops106_terraform_rumman_nacl_public"
  }
}

## security group for web app
resource "aws_security_group" "devops106_terraform_rumman_sg_webserver_tf" {
  name = "devops106_terraform_rumman_sg_webserver"
  vpc_id = local.vpc_id_var

  ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }

  egress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
    }
}
## security group for mongodb
resource "aws_security_group" "devops106_terraform_rumman_sg_mongodb_tf" {
  name = "devops106_terraform_rumman_sg_mongo"
  vpc_id = local.vpc_id_var

   ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
      from_port = 27017
      to_port = 27017
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
      from_port = 0
      to_port = 0
      protocol = -1
      cidr_blocks = ["0.0.0.0/0"]
    }


    tags = {
      "Name" = "devops106_terraform_rumman_sg_webserver"
    }
}
#
data "template_file" "db_init" {
  template = file("./init-scripts/mongo-install.sh")
}

## instance for mongodb server
resource "aws_instance" "devops106_terraform_rumman_mongodb_tf" {
  ami = var.instance_ubuntu_20_04_ami_var
  instance_type = var.instance_type_var
  key_name = var.public_key_name_var
  vpc_security_group_ids = [aws_security_group.devops106_terraform_rumman_sg_mongodb_tf.id]
  subnet_id = local.subnet_mongo_id_var
  associate_public_ip_address = true

  user_data = data.template_file.db_init.rendered
  tags = {
    "Name" = "devops106_terraform_rumman_mongodb_server"
  }

  connection {
    type = "ssh"
    user = "ubuntu"
    host = self.public_ip
    private_key = file(var.private_key_file_path_var)
  }
/*
 provisioner "file" {
   source = "./init-scripts/mongo-install.sh"
   destination = "/home/ubuntu/mongo-install.sh"
}
 provisioner "remote-exec" {
    inline = [
      "bash /home/ubuntu/mongo-install.sh"
    ]
 }
*/
}

data "template_file" "app_init" {
  template = file("./init-scripts/docker-install.sh")
}

#instance for web app
resource "aws_instance" "devops106_terraform_rumman_webserver_tf" {
  ami = var.instance_ubuntu_20_04_ami_var
  instance_type = var.instance_type_var
  key_name = var.public_key_name_var
  vpc_security_group_ids = [aws_security_group.devops106_terraform_rumman_sg_webserver_tf.id]
  subnet_id = local.subnet_webserver_id_var
  associate_public_ip_address = true
####################################################################################################################################################
  count = 2      #makes 2 webservers, count automatically becomes an object
  user_data = data.template_file.app_init.rendered
  tags = {
    "Name" = "devops106_terraform_rumman_webserver_${count.index}"
  }
####################################################################################################################################################
  connection {
    type = "ssh"
    user = "ubuntu"
    host = self.public_ip
    private_key = file(var.private_key_file_path_var)
  }

  /*
  provisioner "file" {
    source = "./init-scripts/docker-install.sh"
    destination = "/home/ubuntu/docker-install.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "bash /home/ubuntu/docker-install.sh"
    ]
  }
  */

#   provisioner "local-exec" {
#    command = "echo ${aws_instance.devops106_terraform_rumman_mongodb_tf.public_ip} > ./database.config"
#  }

#  provisioner "file" {
#    source = "./database.config"
#    destination = "/home/ubuntu/database.config"

#  }
}

resource "aws_route53_zone" "devops106_terraform_rumman_dns_zone_tf" {
  name = "rumman.devops106"

  vpc {
    vpc_id = local.vpc_id_var
  }
}

resource "aws_route53_record" "devops106_terraform_rumman_dns_db_tf" {
  zone_id = aws_route53_zone.devops106_terraform_rumman_dns_zone_tf.zone_id
  name = "db"
  type = "A"
  ttl = "30"
  records = [aws_instance.devops106_terraform_rumman_mongodb_tf.public_ip]
}
