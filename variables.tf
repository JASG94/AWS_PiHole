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