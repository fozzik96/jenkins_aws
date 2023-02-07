output "web_private_ip" {
  value = values(aws_instance.jenkins_main)[*].private_ip
}

output "web_eip" {
  value = aws_eip.jenkins.public_ip
}

output "instance_id" {
  value = values(aws_instance.jenkins_main)[*].id
}

