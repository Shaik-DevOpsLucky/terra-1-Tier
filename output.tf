output "public_ip_of_demo-server" {
    description = "this is the public IP"
    value = aws_instance.demo-server.public_ip
}

output "private_ip_of_demo-server" {
    description = "this is the private IP"
    value = aws_instance.demo-server.private_ip
}
