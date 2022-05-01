resource "aws_vpc" "pipeline-test" {
    cidr_block = "10.0.0.0/24"

    tags = {
      Name = "pipeline test VPC"
    }
}