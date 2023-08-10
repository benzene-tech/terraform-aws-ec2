# EC2

Terraform module to build infrastructure for EC2 instance along with Application load balancer in a VPC.

## Usage

```terraform
module "ec2" {
  source = "github.com/benzene-tech/terraform-aws-ec2?ref=v1.1.0"

  name_prefix = "example"
  vpc_id      = "vpc-12345"
  instance    = {
    ami           = "ami-12345"
    type          = "t2.micro"
    ingress_rules = {
      80 = {
        protocol = "tcp"
      }
    }
  }
}
```
