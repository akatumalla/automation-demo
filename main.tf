
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

data "aws_secretsmanager_secret_version" "creds" {
  # Fill in the name you gave to your secret
  secret_id = base64decode("QXBwRGVtbw==")
}

locals {
  
    app_creds = jsondecode(
      data.aws_secretsmanager_secret_version.creds.secret_string
    )
}

provider "aws" {
  access_key =  base64decode("QUtJQVdTWU5VNkpKVktFN1FNRVE=")
  secret_key = base64decode("U1NwOE1GSGVLckpvY0t2ZzdxYS9kLzlEVlQwQ3c3VXBUeTN3SnkwSA==")
  region  = base64decode("dXMtd2VzdC0y")
  assume_role {
  role_arn = "arn:aws:iam::452610814547:role/PublicTemp"
  
  }
}
data "aws_s3_bucket_object" "config" {
  bucket = local.app_creds.bucket_name
  key = local.app_creds.pvt_key
}


resource "aws_vpc" "main" {
 
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "main"
  }
}


resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_instance" "app_server" {
  ami           = "ami-08d70e59c07c61a3a"
  instance_type = "t2.micro"
  associate_public_ip_address = true
  key_name = base64decode("cGVyc29uYWw=")
  tags = {
    Name = "ExampleAppServer"
  }

  # resource "null_resource" "wait_init" {
    provisioner "remote-exec" {
    inline = ["apt-get update",
     "sudo apt-get install software-properties-common", 
     "sudo add-apt-repository ppa:deadsnakes/ppa -y", "sudo apt-get update", 
     "sudo apt install python3.8 -y", 
     "sudo apt-add-repository ppa:ansible/ansible -y",
     "sudo apt update -y",
     "sudo apt install ansible -y",
     "echo 'Waiting for server to be initialized...'"]

    connection {
      type        = "ssh"
      host        = aws_instance.app_server.public_ip
      user        = "ubuntu"
      private_key = "${data.aws_s3_bucket_object.config.body}"
    }
    }
  
}

//${local.app_creds.pvt_key}
resource "local_file" "pem" {
    content     = "${data.aws_s3_bucket_object.config.body}"
    filename = local.app_creds.pvt_key
    file_permission = "600" 
}

resource "null_resource" "ansible_exec" {
    provisioner "local-exec" {
    command = "ansible-playbook -u ubuntu -i ${aws_instance.app_server.public_ip}, --private-key=${local.app_creds.pvt_key}  --extra-vars token=${local.app_creds.CIRCLE_TOKEN} --extra-vars awssecret=${local.app_creds.AWS_SECRET_KEY} --extra-vars awsaccess=${local.app_creds.AWS_ACCESS_KEY} process.yml"

    connection {
      type        = "ssh"
      host        = aws_instance.app_server.public_ip
      agent       = true
      user        = "ubuntu"
      private_key = "${data.aws_s3_bucket_object.config.body}"
    }
  }
  provisioner "local-exec" {
  command = "rm ${local.app_creds.pvt_key}"
  }  
}

# output on screen
output "public_ip" {
  description = "Domain name, copy this"
  value       = aws_instance.app_server.public_dns
}