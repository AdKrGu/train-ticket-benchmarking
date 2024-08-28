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
