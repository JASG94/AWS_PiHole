# Get ami identifier
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] 
}

# Create PiHole Security Group
resource "aws_security_group" "pihole" {
  name        = "pihole"
  description = "Allow HTTP and DNS inbound traffic"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "DNS"
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "pihole"
  }
}


# Create and provisioning EC2 instance
resource "aws_instance" "PiHole" {

  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name = var.key_name
  security_groups = [
    "pihole"
  ]
 
  tags = {
    Name = "PiHole"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get -y upgrade",
      "sudo apt-get install -y docker.io docker-compose",
      "mkdir /home/ubuntu/docker"
    ] 
    connection {
      host        = self.public_ip
      type        = "ssh"
      private_key = file(var.ssh_key)
      user        = "ubuntu"
      timeout     = "1m"
    }
  }

  provisioner "file" {
    source = "./files/docker-compose.yml"
    destination = "/home/ubuntu/docker/docker-compose.yml"
    connection {
      host        = self.public_ip
      type        = "ssh"
      private_key = file(var.ssh_key)
      user        = "ubuntu"
      timeout     = "1m"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo docker pull pihole/pihole:latest",
      "sudo systemctl stop systemd-resolved",
      "sudo systemctl disable systemd-resolved",
      "cd /home/ubuntu/docker && sudo docker-compose up -d",
      "sudo sed -i 's/nameserver 127.0.0.53/nameserver 127.0.0.1/g' /etc/resolv.conf"
    ]
    connection {
      host        = self.public_ip
      type        = "ssh"
      private_key = file(var.ssh_key)
      user        = "ubuntu"
      timeout     = "1m"
    }
  
  }
}