# Specify the AWS provider
provider "aws" {
  region     = "us-east-1"
  access_key = "YOUR_AWS_ACCESS_KEY"
  secret_key = "YOUR_AWS_SECRET_KEY"
}

# ------------ VARIABLES ------------ #
# variable "aws_region" {
#   default = "us-east-1"
# }

variable "bucket_name" {
  default = "sri-demo-bucket-12345"  # Must be globally unique
}

# Create a security group that allows SSH access
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create the EC2 instance
resource "aws_instance" "example" {
  ami                    = "ami-05b10e08d247fb927" # Amazon Linux 2 AMI in us-east-1
  instance_type          = "t3.medium"
  security_groups        = [aws_security_group.allow_ssh.name]
 # key_name               = "your-keypair-name"     # Replace with your AWS Key Pair name

  tags = {
    Name = "Terraform-EC2"
  }
}

# ------------ S3 BUCKET ------------ #
resource "aws_s3_bucket" "demo_bucket" {
  bucket = var.bucket_name

  tags = {
    Name        = "Sri-Terraform-Bucket"
    Environment = "Dev"
  }
}

# OUTPUT BLOCKS

# Public IP
output "ec2_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.example.public_ip
}

# Instance ID
output "ec2_instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.example.id
}

# AMI used
output "ami_id" {
  description = "AMI used to launch the instance"
  value       = aws_instance.example.ami
}

output "s3_bucket_name" {
  description = "The name of the created S3 bucket"
  value       = aws_s3_bucket.demo_bucket.bucket
}

# AWS Region
# output "aws_region" {
#   description = "AWS region being used"
#   value       = var.aws_region
# }

