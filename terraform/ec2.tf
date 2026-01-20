# ------------------------------
# IAM Role & Instance Profile for SSM
# ------------------------------
resource "aws_iam_role" "ssm_role" {
  name = "ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_attach" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_profile" {
  name = "ssm-instance-profile"
  role = aws_iam_role.ssm_role.name
}

# ------------------------------
# Key Pair
# ------------------------------
resource "aws_key_pair" "devops_key" {
  key_name   = "devops-key"
  public_key = file("devops-key.pub")
}

# ------------------------------
# Elastic IP for Web Server
# ------------------------------
resource "aws_eip" "web_server_eip" {
  tags = {
    Name = "web-server-eip"
  }
}

# ------------------------------
# Web Server (Public Subnet)
# ------------------------------
resource "aws_instance" "web_server" {
  ami           = "ami-0c687e8f5c4e54af5"  # Replace with valid Ubuntu AMI for your region
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.public.id
  private_ip    = "10.0.0.5"
  key_name      = aws_key_pair.devops_key.key_name
  vpc_security_group_ids = [aws_security_group.devops_public_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ssm_profile.name

  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update
              sudo apt install -y amazon-ssm-agent
              sudo systemctl enable amazon-ssm-agent
              sudo systemctl start amazon-ssm-agent
              EOF

  tags = {
    Name = "web-server"
  }
}

# Associate Elastic IP to Web Server
resource "aws_eip_association" "web_server_eip_assoc" {
  instance_id   = aws_instance.web_server.id
  allocation_id = aws_eip.web_server_eip.id
}

# ------------------------------
# Ansible Controller (Private Subnet)
# ------------------------------
resource "aws_instance" "ansible_controller" {
  ami           = "ami-0c687e8f5c4e54af5"
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.private.id
  private_ip    = "10.0.0.135"
  key_name      = aws_key_pair.devops_key.key_name
  vpc_security_group_ids = [aws_security_group.devops_private_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ssm_profile.name

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update
              sudo apt install -y amazon-ssm-agent
              sudo systemctl enable amazon-ssm-agent
              sudo systemctl start amazon-ssm-agent
              EOF

  tags = {
    Name = "ansible-controller"
  }
}

# ------------------------------
# Monitoring Server (Private Subnet)
# ------------------------------
resource "aws_instance" "monitoring_server" {
  ami           = "ami-0c687e8f5c4e54af5"
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.private.id
  private_ip    = "10.0.0.136"
  key_name      = aws_key_pair.devops_key.key_name
  vpc_security_group_ids = [aws_security_group.devops_private_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ssm_profile.name

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update
              sudo apt install -y amazon-ssm-agent
              sudo systemctl enable amazon-ssm-agent
              sudo systemctl start amazon-ssm-agent
              EOF

  tags = {
    Name = "monitoring-server"
  }
}

