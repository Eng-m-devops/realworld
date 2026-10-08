variable "ssh_public_key_path" {
  description = "Path to the SSH public key file"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}
