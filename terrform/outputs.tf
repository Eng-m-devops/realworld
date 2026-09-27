output "server_public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = aws_instance.my_first_ec2.public_ip
}