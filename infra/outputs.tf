output "instance_public_ip" {
  description = "The public IP address of the app server instance."
  value       = aws_instance.app_instance.public_ip
}

output "jenkins_instance_private_ip" {
  description = "The private IP address of the Jenkins instance."
  value       = aws_instance.jenkins_instance.private_ip
}

output "jenkins_instance_public_ip" {
  description = "The public IP address of the Jenkins instance."
  value       = aws_instance.jenkins_instance.public_ip
}
