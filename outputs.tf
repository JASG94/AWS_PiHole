output "PiholeIP" {
  description = "PiHole IP"
  value       = aws_instance.PiHole.public_ip
}
