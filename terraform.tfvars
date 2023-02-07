jenkins_ports    = ["80", "8080", "443", "8843"]
instance_type    = "t2.micro"
root_volume_size = "30"
root_volume_type = "gp2"
key_pair         = "jenkins-key"
tags = {
  Owner       = "Kirill Pavlov"
  Project     = "Education"
  Environment = "Production"
}