provider "aws" {
	  access_key = "${var.access_key}"
	  secret_key = "${var.secret_key}"
	  region     = "${var.region}"
}

# Creating Security Group, allow ssh and http

resource "aws_security_group" "allow_ssh_http" {
	name        = "allow_ssh_http"
	description = "Allow ssh and http traffic"
	
	ingress {
		from_port   = 22
		to_port     = 22
		protocol =   "tcp"
		cidr_blocks =  ["0.0.0.0/0"]
		}

	ingress {
		from_port   = 80 #  Allow port 80 for HTTP traffic
		to_port     = 80
		protocol =   "tcp"
		cidr_blocks =  ["0.0.0.0/0"]
		}
		
	egress {
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]
		}
}
	
# Creating AWS Instance
 
resource "aws_instance" "HelloWorld" {
	ami           = "ami-0a887e401f7654935"
	instance_type = "t2.micro"
	security_groups = ["${aws_security_group.allow_ssh_http.name}"]
    key_name = "terraform-key"
	tags = { 
		Name = "AWS EC2 Web Instance"
		}
	user_data = <<-EOF
				#! /bin/bash
				yum update -y
				yum install -y httpd
				sudo echo "<h1>Hello from $(dig +short myip.opendns.com @resolver1.opendns.com)</h1>" >> /var/www/html/index.html
				service httpd start
				EOF				
}	