terraform {
    backend "s3" {
        bucket = "tfstate-backend-test"
        key = "global/codepipeline/terraform.tfstate"
        region = "eu-west-2"
        dynamodb_table = "tfstate-locking-table-test"
        encrypt = true
    }
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 4.0"
        }
    }
}
provider "aws" {
    region = var.aws-region
}


