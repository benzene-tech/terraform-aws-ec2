# EC2

Terraform module to build infrastructure for EC2 instance along with Application load balancer in a VPC.

## Usage

```terraform
module "ec2" {
  source = "github.com/benzene-tech/terraform-aws-ec2"

  name   = "example"
  vpc_id = "vpc-12345"

  ami = {
    id   = "ami-12345"
    type = "t2.micro"
  }

  subnet = {
    availability_zone = "ap-south-1a"
  }
}
```
