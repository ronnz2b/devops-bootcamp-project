# ------------------------------
# VPC
# ------------------------------
resource "aws_vpc" "devops" {
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "devops-vpc"
  }
}

# ------------------------------
# Subnets
# ------------------------------
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.devops.id
  cidr_block              = "10.0.0.0/25"
  map_public_ip_on_launch = true
  availability_zone       = "ap-southeast-1a"

  tags = {
    Name = "devops-public-subnet"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.devops.id
  cidr_block        = "10.0.0.128/25"
  availability_zone = "ap-southeast-1a"

  tags = {
    Name = "devops-private-subnet"
  }
}

# ------------------------------
# Internet Gateway
# ------------------------------
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.devops.id

  tags = {
    Name = "devops-igw"
  }
}

# ------------------------------
# NAT Gateway
# ------------------------------
resource "aws_eip" "nat" {
  tags = {
    Name = "devops-nat-eip"
  }
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "devops-ngw"
  }
}

# ------------------------------
# Route Tables
# ------------------------------
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.devops.id

  tags = {
    Name = "devops-public-route"
  }
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.devops.id

  tags = {
    Name = "devops-private-route"
  }
}

resource "aws_route" "private_nat" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main.id
}

resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}
