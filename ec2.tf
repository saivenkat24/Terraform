
#EC2 INFO
resource "aws_instance" "server" {
  ami = "ami-0763cf792771fe1bd"
  instance_type = "t2.micro"
  key_name = "docker"
  subnet_id = aws_subnet.public-subnet.id  

}




