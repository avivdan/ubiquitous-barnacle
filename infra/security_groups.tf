### --- Security Groups for Jenkins instance --- ###

resource "aws_security_group" "private_sg" {
  name        = "private_security_group"
  description = "The security group for jenkins instance"
  vpc_id      = aws_vpc.main.id

  # Allow SSH from within the VPC and from the specific IP address
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block, "${var.testing_ip}"]
  }
  # Allow Jenkins web interface access from within the VPC and from the specific IP address
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block, "${var.testing_ip}"]
  }
  # Allow Jenkins agent communication with flask instance
  ingress {
    from_port   = 50000
    to_port     = 50000
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }
  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.project_name}-private-sg"
    Project = "${var.project_name}"
  }
}



########## -- Public Security Group - allow SSH and all outbound traffic ##########
resource "aws_security_group" "public_sg" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.main.id

  # Allow SSH from within the VPC and from the specific IP address
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block, "${var.testing_ip}"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block, "${var.testing_ip}"]
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block, "${var.testing_ip}"]
  }

  # send jenkins instance traffic from flask instance
  egress {
    from_port   = 50000
    to_port     = 50000
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block, "${var.testing_ip}"]
  }

  # outbound traffic to the internet
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.project_name}-public-sg"
    Project = "${var.project_name}"
  }
}
