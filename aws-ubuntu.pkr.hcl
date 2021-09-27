packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "ubuntu-linux-aws"
  instance_type = "t2.micro"
  region        = "us-west-1"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-bionic-18.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
}

build {
  name = "install-pre-install packages"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]

  provisioner "shell" {
    environment_vars = [
      "TEST=Installing pre-installation packeges",
    ]
    inline = [
      "echo Installing pre-installation packeges packages",
      "sleep 30",
      "sudo apt-get update",
      "sudo apt-get install git -y",
      "git clone https://github.com/satender346/devops-automation.git",
      "cd devops-automation && bash packer.sh",
 #     "git clone https://github.com/satender346/jenkins-kubernetes-helm-deployment.git",
 #     "cd jenkins-kubernetes-helm-deployment",
 #     "bash deploy_jenkins_chart.sh",
    ]
  }

  provisioner "shell" {
    inline = ["echo This provisioner runs last"]
  }
  provisioner "file" {
    source = "/var/jenkins_home/aws_credentials"
    destination = "/var/jenkins_home/aws_credentials"
  }
}

