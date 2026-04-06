resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name    = "${var.project_name}-vpc"
    project = "${var.project_name}"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    "project" = "${var.project_name}"
    "Name"    = "${var.project_name}-igw"
  }
}

resource "aws_route_table" "rtb" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    "project" = "${var.project_name}"
    "Name"    = "${var.project_name}-rtb"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.rtb.id
}

resource "aws_route_table" "jenkins_rtb" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    "project" = "${var.project_name}"
    "Name"    = "${var.project_name}-jenkins-rtb"
  }
}

resource "aws_route_table_association" "jenkins" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.jenkins_rtb.id
}
