output "webservers_ip_addresses" {
  value = aws_instance.devops106_terraform_rumman_webserver_tf[*].public_ip
}

output "mongodbservers_ip_addresses" {
  value = aws_instance.devops106_terraform_rumman_mongodb_tf[*].public_ip
}
