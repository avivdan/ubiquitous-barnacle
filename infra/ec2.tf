data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["${var.owner}"]

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = var.ssh_public_key
}


resource "aws_instance" "jenkins_instance" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.micro"
  associate_public_ip_address = true
  key_name                    = aws_key_pair.deployer.key_name
  vpc_security_group_ids      = [aws_security_group.private_sg.id]
  subnet_id                   = aws_subnet.private_subnet.id

  user_data = templatefile("../scripts/jenkins.sh", {
    jenkins_admin_password = var.jenkins_admin_password
    docker_hub_username    = var.docker_hub_username
    docker_hub_password    = var.docker_hub_password
  })

  tags = {
    Name    = "${var.project_name}-jenkins-instance"
    project = "${var.project_name}"
  }
}


resource "aws_instance" "app_instance" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.micro"
  associate_public_ip_address = true
  key_name                    = aws_key_pair.deployer.key_name
  vpc_security_group_ids      = [aws_security_group.public_sg.id]
  subnet_id                   = aws_subnet.public_subnet.id

  user_data = templatefile("../scripts/flask.sh", {
    master_private_ip      = aws_instance.jenkins_instance.private_ip
    jenkins_admin_password = var.jenkins_admin_password
    docker_hub_username    = var.docker_hub_username
    docker_hub_password    = var.docker_hub_password
  })

  depends_on = [aws_instance.jenkins_instance]

  tags = {
    Name    = "${var.project_name}-app-instance"
    project = "${var.project_name}"
  }
}


resource "github_repository_webhook" "jenkins" {
  repository = "ubiquitous-barnacle"

  configuration {
    url          = "http://${aws_instance.jenkins_instance.public_ip}:8080/github-webhook/"
    content_type = "json"
    insecure_ssl = true
  }

  events = ["push"]

  depends_on = [aws_instance.jenkins_instance]
}
