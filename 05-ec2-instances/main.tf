variable "aws_key_pair" {
  default = "~/Documents/devops-master-class/aws/aws_keys/default-ec2.pem"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_default_vpc" "default" {
  //este recurso se crea para no tener qe hardcodear el valor de vpc_id, esto se va a ejecutar
  //la ejecuacion va a crear el recurso con un valor id, qe se puede ver con console o en
  //terraform.tfstate, con esto ya se podria reemplazar el valor por el de la variable
}

data "aws_subnets" "default_subnets" { //subnets es de tipo data, no resrouce, default_subnets es un identificador para el recurso de datos aws_subnets
  filter {
    name   = "vpc-id" //name se refiere al nombre del filtro que se aplica a los subnets, otros valores qe puede tomar son: subnet-id, availability-zone y cidr-block
    values = [aws_default_vpc.default.id]
  }
} //este valor va en subnet_id de aws_instance

data "aws_ami" "aws-linux-2-latest" {
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

//http server -> SG
//SG -> 80 TCP -> 22 TCP, CIDR ["0.0.0.0/0"]

resource "aws_security_group" "http_server_sg" {
  name   = "http_server_sg"
  vpc_id = aws_default_vpc.default.id //"vpc-02e46bf09de075d3d"

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

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0 //se permite todo el tráfico de salida hacia cualquier puerto y protocolo
    to_port     = 0
    protocol    = -1 //se permiten todos los protocolos
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "http_server" {
  ami                    = data.aws_ami.aws-linux-2-latest.id //"ami-0f88e80871fd81e91"
  key_name               = "default-ec2"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.http_server_sg.id]  //["sg-046979bc253a2cfcf"]
  subnet_id              = data.aws_subnets.default_subnets.ids[0] //"subnet-093bc5317583ec8d2"

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file(var.aws_key_pair)
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install httpd -y",                                                       //install httpd
      "sudo service httpd start",                                                        //start
      "echo virtual server is at ${self.public_dns} | sudo tee /var/www/html/index.html" //cop a file
    ]
  }
}