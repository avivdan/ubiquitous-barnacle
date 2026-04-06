variable "testing_ip" {
  type    = string
  default = "172.25.240.1/32"
}

variable "project_name" {
  type    = string
  default = "project-4"
}

variable "region" {
  type    = string
  default = "eu-north-1"
}

variable "availability_zone" {
  type    = string
  default = "eu-north-1a"
}

variable "owner" {
  type    = string
  default = "099720109477"
}

variable "path" {
  type    = string
  default = "C:/Users/gideo/Desktop/aws"
}

variable "jenkins_admin_password" {
  type      = string
  sensitive = true
}

variable "docker_hub_username" {
  type      = string
  sensitive = true
}

variable "docker_hub_password" {
  type      = string
  sensitive = true
}
