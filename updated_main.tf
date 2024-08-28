provider "aws" {
  region = "ap-south-1"
}

# Create an EC2 instance where the microservice will be deployed
resource "aws_instance" "web" {
  ami           = "ami-0522ab6e1ddcc7055"  # Provided Ubuntu AMI
  instance_type = "t2.small"
  key_name      = "Terraform_Cloudformation_Benchmarking"  # Provided key pair

  # Use the provided security group and subnet
  vpc_security_group_ids = ["sg-05e5f12096a41cf7e"]
  subnet_id              = "subnet-017628f851b314f3c"  # Provided Subnet ID

  # Enable public IP
  associate_public_ip_address = true

  tags = {
    Name = "Terraform-EC2-${basename(abspath(path.module))}"  # Unique name based on the microservice directory name
  }
}

# Create a new 10GB EBS volume
resource "aws_ebs_volume" "ebs_volume" {
  availability_zone = aws_instance.web.availability_zone
  size              = 10
  tags = {
    Name = "Terraform-EBSSVolume-${basename(abspath(path.module))}"  # Unique name for the EBS volume
  }
}

# Attach the EBS volume to the EC2 instance
resource "aws_volume_attachment" "ebs_attachment" {
  device_name = "/dev/xvdf"
  volume_id   = aws_ebs_volume.ebs_volume.id
  instance_id = aws_instance.web.id
}

# Create an S3 bucket with the same name as the EC2 instance
resource "aws_s3_bucket" "web_bucket" {
  bucket = "terraform-ec2-${basename(abspath(path.module))}"

  tags = {
    Name = "Terraform-S3Bucket-${basename(abspath(path.module))}"
  }
}

# Create a CloudWatch log group
resource "aws_cloudwatch_log_group" "web_log_group" {
  name = "Terraform-EC2-Logs-${basename(abspath(path.module))}"
}

# Create an IAM role for CloudWatch agent
resource "aws_iam_role" "cloudwatch_agent_role" {
  name = "Terraform-CloudWatchAgentRole-${basename(abspath(path.module))}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Attach policy to the IAM role
resource "aws_iam_role_policy_attachment" "cloudwatch_agent_policy" {
  role       = aws_iam_role.cloudwatch_agent_role.name
  policy_arn  = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# Create an instance profile for the EC2 instance
resource "aws_iam_instance_profile" "web_instance_profile" {
  name = "Terraform-EC2InstanceProfile-${basename(abspath(path.module))}"
  role = aws_iam_role.cloudwatch_agent_role.name
}

# Attach the instance profile to the EC2 instance
resource "aws_instance" "web" {
  ami           = "ami-0522ab6e1ddcc7055"  # Provided Ubuntu AMI
  instance_type = "t2.small"
  key_name      = "Terraform_Cloudformation_Benchmarking"  # Provided key pair

  # Use the provided security group and subnet
  vpc_security_group_ids = ["sg-05e5f12096a41cf7e"]
  subnet_id              = "subnet-017628f851b314f3c"  # Provided Subnet ID

  # Enable public IP
  associate_public_ip_address = true

  # Associate the IAM instance profile with the EC2 instance
  iam_instance_profile = aws_iam_instance_profile.web_instance_profile.name

  tags = {
    Name = "Terraform-EC2-${basename(abspath(path.module))}"  # Unique name based on the microservice directory name
  }
}

