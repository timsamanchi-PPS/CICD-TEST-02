data "aws_iam_policy" "permissions_boundary" {
    arn = var.permissions_boundary
}
data "aws_iam_policy_document" "tf-cicd-pipeline-policies" {
  statement {
    sid = "statement1"
    effect = "Allow"
    resources = ["*"]
    actions = ["codestar-connections:UseConnection"]
  }
  statement {
    sid = "statement2"
    effect = "Allow"
    resources = ["*"]
    actions = ["s3:*","codebuild:*","cloudwatch:*"]
  }
}
data "aws_iam_policy_document" "tf-cicd-build-policies" {
  statement {
    sid = "statement1"
    effect = "Allow"
    resources = ["*"]
    actions = ["s3:*","iam:*","logs:*","codebuild:*","secretsmanager:*"]
  }
}
