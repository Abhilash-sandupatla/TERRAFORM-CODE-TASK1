provider "aws"{
 region= "ap-south-1"
 profile= "abhilashterra"
 }

resource "aws_key_pair" "myterratask1" {
key_name = "myterratask1"
public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3F6tyPEFEzV0LX3X8BsXdMsQz1x2cEikKDEY0aIj41qgxMCP/iteneqXSIFZBp5vizPvaoIR3Um9xK7PGoW8giupGn+EPuxIA4cDM4vzOqOkiMPhz5XK0whEjkVzTo4+S0puvDZuwIsdiW9mxhJc7tgBNL0cYlWSYVkz4G/fslNfRPW5mYAM49f4fhtxPb5ok4Q2Lg9dPKVHO/Bgeu5woMc7RY0p1ej6D4CKFE6lymSDJpW0YHX/wqE9+cfEauh7xZcG0q9t2ta6F6fmX0agvpFyZo8aFbXeUBr7osSCJNgvavWbM/06niWrOvYX2xwWdhXmXSrbX8ZbabVohBK41 sandupatlaabhilash1747@gmail.com"
}

resource "aws_security_group" "myterratask1security" {
name = "myterratask1security"
description = "Allow TLS inbound traffic"
vpc_id = "vpc-ca5f43a2"
ingress {
description = "SSH"
from_port = 22
to_port = 22
protocol = "tcp"
cidr_blocks = [ "0.0.0.0/0" ]
}
ingress {
description = "HTTP"
from_port = 80
to_port = 80
protocol = "tcp"
cidr_blocks = [ "0.0.0.0/0" ]
}
egress {
from_port = 0
to_port = 0
protocol = "-1"
cidr_blocks = ["0.0.0.0/0"]
}
tags = {
Name = "myterratask1security"
}
}

resource "aws_s3_bucket" "abhilashs3bucket1747" {
bucket = "abhilashs3bucket1747"
 acl = "public-read"
tags = {
Name = "abhilashs3bucket1747"
 }
}
locals {
s3_origin_id = "myS3Origin"
}
resource "aws_s3_bucket_object" "abhilashs3bucket1747" {
bucket = "abhilashs3bucket1747"
 key = "Screenshot_2020–04–09–17–48–31–86.jpg"
 source = "/home/abhilash/Desktop/Screenshot_2020-04-09-17-48-31-86.jpg"
 acl = "public-read"
}
 resource "aws_cloudfront_distribution" "AbhilashCloudfront1747" {
  origin {
    domain_name = aws_s3_bucket.abhilashs3bucket1747.bucket_regional_domain_name
    origin_id   = local.s3_origin_id


    custom_origin_config {
    http_port = 80
    https_port = 80
    origin_protocol_policy = "match-viewer"
    origin_ssl_protocols = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }


  enabled             = true


  default_cache_behavior {

    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]

    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id


    forwarded_values {
     query_string = false


      cookies {
        forward = "none"
      }
    }


   viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }


 
   restrictions {
     geo_restriction {
      restriction_type = "none"
    }
  }


  viewer_certificate {
    cloudfront_default_certificate = true  

  }
   depends_on = [
    aws_s3_bucket.abhilashs3bucket1747
 ]
}
 
 resource "aws_ebs_volume" "myterratask1volume" {
availability_zone = "ap-south-1a"
size = 1
tags = {
Name = "myterratask1volume"
}
}
  
resource "aws_volume_attachment" "myterratask1volume" {
device_name = "/dev/sdf"
volume_id = "${aws_ebs_volume.myterratask1volume.id}"
instance_id = "${aws_instance.myterratask01instance.id}"
}
 
 resource "aws_instance" "myterratask01instance" {
ami = "ami-0447a12f28fddb066"
instance_type = "t2.micro"
availability_zone = "ap-south-1a"
key_name = "myterratask1"
security_groups = [ "myterratask1security" ]
user_data = <<-EOF
#! /bin/bash
sudo yum update -y
sudo yum install httpd -y
sudo systemctl start httpd
sudo systemctl enable httpd
sudo yum install git -y
mkfs.ext4 /dev/xvdf1
mount /dev/xvdf1 /var/www/html
cd /var/www/html
git  clone https://github.com/Abhilash-sandupatla/MYTERRAFORM-PROJECT.git

EOF
tags = {
Name = "myterratask01instance"
}
}
