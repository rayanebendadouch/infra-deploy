terraform{
   required_providers{
 aws = {
    source="hachicorp/aws"
    version="~>5.0"
 }
   }
   backend "s3" {
    bucket="my-terr-bucket"
    key="myapp/file.tfstate"
    region=var.region
     
   }
    
    }
provider "aws" {
  region=var.region

}

resource "aws_instance" "fisrt-inst"{

    ami="ami-0a7d80731ae1b2435 (64-bit (x86))"
    instance_type="t2.micro"
    key_name=aws_key_pair.key_name
    iam_instance_profile=aws_iam_instance_profile.profile.name
    vpc_security_group_ids=[aws_security_group.id]
    connection {
      type="ssh"
      host = self.public_ip
      user = "ubuntu"
      private_key = var.private_key
      //terraform va attensre 15s pour se conecter a la machine sinon elle return erreur
     timeout = "15s"
    } 
}

resource "aws_iam_instance_profile" "profile" {
    name="my-ec2"
    role="kroos"
  
}
resource "aws_security_group" "my-rules" {

  name="who allows"

}

resource "aws_vpc_security_group_ingress_rule" "inbound-rules" {
    security_group_id=aws_security_group.my-rules.id
    cidr_block=["0.0.0.0/0"]
    from_port=22
    ip_protocol="tcp"
    to_port=22

}
resource "aws_vpc_security_group_ingress_rule" "inbound-rules" {
    security_group_id=aws_security_group.my-rules.id
    cidr_block=["0.0.0.0/0"]
    from_port=80
    ip_protocol="tcp"
    to_port=80

}
resource "aws_vpc_security_group_egress_rule" "inbound-rules" {
    security_group_id=aws_security_group.my-rules.id
    cidr_block=["0.0.0.0/0"]
    from_port=0
    ip_protocol="-1"
    to_port=0

}
resource "aws_key_pair" "my-key" {
key_name=var.key_name
public_key=var.public_key
  
}

output "instance_public_ip" {
    value = aws_instance.fisrt-inst.public_ip
  
}