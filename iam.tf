# create iam role for codepipeline service
resource "aws_iam_role" "tf-codepipeline-role" {
  name = "tf-codepipeline-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
        Service = "codepipeline.amazonaws.com"
        }
      },
    ]
  })

  permissions_boundary = data.aws_iam_policy.permissions_boundary.arn

  tags = {
    Name = "tf-codepipeline-role"
  }
}
resource "aws_iam_policy" "tf-cicd-pipeline-policy" {
  description = "pipeline policy"
  name = "tf-cicd-pipeline-policy"
  path = "/"
  policy = data.aws_iam_policy_document.tf-cicd-pipeline-policies.json
}
resource "aws_iam_role_policy_attachment" "tf-cicd-pipeline-attachment" {
  role = aws_iam_role.tf-codepipeline-role.name
  policy_arn = aws_iam_policy.tf-cicd-pipeline-policy.arn
}
# create iam role for codebuild service

resource "aws_iam_role" "tf-codebuild-role" {
  name = "tf-codebuild-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
        Service = "codebuild.amazonaws.com"
        }
      },
    ]
  })

  permissions_boundary = data.aws_iam_policy.permissions_boundary.arn

  tags = {
    Name = "tf-codebuild-role"
  }
}

