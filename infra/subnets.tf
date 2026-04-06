resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "${var.region}b"
  tags = {
    Project = "${var.project_name}"
    Name    = "${var.project_name}-private-subnet"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = true

  tags = {
    Project = "${var.project_name}"
    Name    = "${var.project_name}-public-subnet"
  }
}
