data "aws_ami" "windows" {
    most_recent = true

    filter {
        name   = "name"
        values = ["Windows_Server-2012-R2_RTM-English-*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }
    
    owners = ["801119661308"] # Canonical
}

provider "aws" {
  region  = "ap-south-1"
}

data "aws_iam_role" "myrole" {
  name = "myfullaccessrole"
}

resource "aws_iam_instance_profile" "test_profile" {
  name = "myprofile"
  role = data.aws_iam_role.myrole.name
}

resource "aws_instance" "win_server" {
  ami           = data.aws_ami.windows.id
  instance_type = "t2.micro"
  key_name      = "MyEC2Instance"
  security_groups = [ "mySG" ]
  iam_instance_profile = aws_iam_instance_profile.test_profile.name
  user_data = file("script.ps1")

  tags = {
    Name = var.ec2_name
  }
}
