data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  owners = ["099720109477"]
}

resource "aws_instance" "devops_node" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.lab_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  user_data = <<-EOF
              #!/bin/bash
              set -e
              apt-get update -y
              apt-get install -y curl unzip software-properties-common

              # Install Docker
              curl -fsSL https://get.docker.com -o get-docker.sh
              sh get-docker.sh
              usermod -aG docker ubuntu

              # Install Ansible
              add-apt-repository --yes --update ppa:ansible/ansible
              apt-get install -y ansible

              # Run Nginx Container as Health Check
              docker run -d -p 80:80 --name lab-web nginx

              echo "Deployment Successful" > /home/ubuntu/status.txt
              EOF

  tags = { Name = "${var.project_name}-node" }
}
