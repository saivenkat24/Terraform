#PROVIDER INFO
 provider "aws" {
  region     = "ap-south-1"
  access_key = "AKIAVPISO7X47TKGRHUN"
  secret_key = "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"
}

resource "aws_vpc" "myvpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "myvpc"
  }
}

resource "aws_subnet" "public-subnet" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.0.0/20"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "public-subnet"
  }
}

resource "aws_internet_gateway" "IGW" {
    vpc_id = aws_vpc.myvpc.id
  
    tags = {
      Name = "IGW"
    }
  }

  resource "aws_route_table" "public-rt" {
    vpc_id = aws_vpc.myvpc.id
  
    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.IGW.id
    }
  }

  resource "aws_route_table_association" "a" {
    subnet_id      = aws_subnet.public-subnet.id
    route_table_id = aws_route_table.public-rt.id
  }

  resource "aws_security_group" "SG" {
    name = "SG"
    description = "Allow HTTP and SSH"
  
    ingress {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  
    ingress {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  
    egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

#EC2 INFO
resource "aws_instance" "server" {
  ami = "ami-0763cf792771fe1bd"
  instance_type = "t2.micro"
  key_name = "docker"
  subnet_id = aws_subnet.public-subnet.id  

}
