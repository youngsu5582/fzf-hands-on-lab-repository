variable "aws_profile" {
  description = "AWS CLI profile name"
  type        = string
  default     = "joyson"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-2"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string
  default     = "fzf-lab-instance"
}

variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
  default     = "fzf-lab-key"
}

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed to SSH into the instance"
  type        = string
  default     = "0.0.0.0/0"
}
