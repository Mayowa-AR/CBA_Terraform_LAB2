provider "aws" {
 region = var.region
}

resource "aws_vpc" "my_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  instance_tenancy     = "default"
  tags = {
    name = "ApacheVPC"
  }
}

resource "aws_subnet" "cba_public" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "eu-west-1a"

  tags = {
    Name = "ApachePublicSubnet"
  }
}

resource "aws_subnet" "cba_private" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "eu-west-1b"

  tags = {
    Name = "ApachePrivateSubnet"
  }
}

resource "aws_internet_gateway" "cba_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "ApacheIGW"
  }
}

resource "aws_route_table" "cba_public_rt" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cba_igw.id
  }

  tags = {
    "Name" = "ApachePublicRT"
  }

}

resource "aws_route_table_association" "cba_subnet_rt_public" {
  subnet_id      = aws_subnet.cba_public.id
  route_table_id = aws_route_table.cba_public_rt.id
}

