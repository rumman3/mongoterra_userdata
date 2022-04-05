variable "private_key_file_path_var" {
  default = "/home/vagrant/.ssh/devops106_muhammadalam.pem"
}

variable "instance_ubuntu_20_04_ami_var" {
  default = "ami-08ca3fed11864d6bb"
}

variable "instance_type_var" {
  default = "t2.micro"
}

variable "public_key_name_var" {
  default = "devops106_muhammadalam"
}

variable "region_var" {
  default = "eu-west-1"
}

locals {
  vpc_id_var = aws_vpc.devops106_terraform_rumman_vpc_tf.id
  subnet_mongo_id_var = aws_subnet.devops106_terraform_rumman_subnet_mongodb_tf.id
  subnet_webserver_id_var = aws_subnet.devops106_terraform_rumman_subnet_webserver_tf.id
  route_table_id_var = aws_route_table.devops106_terraform_rumman_rt_public_tf.id
}
