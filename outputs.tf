output "web_private_ip" {
  value = aws_instance.my_ubuntu.private_ip
}

output "web_eip" {
  value = aws_eip.jenkins.public_ip
}