provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.main.id
}

resource "aws_subnet" "subnet_one" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "subnet_two" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1b"
}

resource "aws_instance" "instance_one" {
  ami           = "ami-0fcfd45b96222a2ae"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet_one.id
}

resource "aws_instance" "instance_two" {
  ami           = "ami-0fcfd45b96222a2ae"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet_two.id
}

resource "aws_lb" "app_load_balancer" {
  subnets  = [aws_subnet.subnet_one.id, aws_subnet.subnet_two.id]
  internal = false
  #depends_on = [aws_internet_gateway.ig]
}
