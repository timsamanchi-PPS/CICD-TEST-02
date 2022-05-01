variable "aws-region" {
    description = "aws region used for this test"
    type = string
}
variable "artifacts-bucket" {
    description = "codebuild artifacts s3 bucket"
    type = string
}
variable "permissions_boundary" {
    description = "required permissions boundary string"
    type = string
  
}