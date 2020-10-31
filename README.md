# PiHole deployed on AWS EC2

![N|Solid](https://upload.wikimedia.org/wikipedia/commons/5/5e/Pi-hole_Screenshot.png)

## Requirements
In order to use it Terraform v0.13.5 (not tested in other versions) will be needed

## Usage
In order to have it deployed well need to run:
```sh
$ git clone https://github.com/JASG94/AWS_PiHole.git
$ cd AWS_PiHole
$ terraform init
```
In order to continue we need an AWS created with SSH Keys and configured in our laptop. Also AWS credentials should be configured.

The deployment could be customized by the following variables in variables.tf file:
```
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "SSH Key AWS name"
  type        = string
  default     = "awskey"
}

variable "ssh_key" {
  description = "SSH Key directory path"
  type        = string
  default     = "/home/javi/ssh_keys/aws.pem"
}
```
Once configured, to proceed with the deployment:
```sh
$ terraform apply --autoaprove
```

This will create:
  - A new Security Group allowing only SSH, HTTP and DNS incoming traffic
  - An EC2 instanci with docker and docker-compose installed and runing pi-hole.

The output will tell us the public IPv4 of our EC2 instance where we can find PiHole running.