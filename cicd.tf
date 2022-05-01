# CICD pipeline
# 1- create aws-codebuild project for terraform a)plan and b)pply
# 2- creat 3 stage CI/CD aws-codepipeline 
#
# 1.a- terraform plan
resource "aws_codebuild_project" "tf-plan" {
    description = "plan stage for terraform"
    name = "tf-cicd-plan"
    service_role = aws_iam_role.tf-codebuild-role.arn

    artifacts {
      type = "CODEPIPELINE"
    }

    environment {
      compute_type = "BUILD_GENERAL1_SMALL"
      image = "hashicorp/terraform:latest"
      type = "LINUX_CONTAINER"
      image_pull_credentials_type = "SERVICE_ROLE"
      registry_credential {
        credential = var.dockerHub-credentials
        credential_provider = "SECRETS_MANAGER"
      }
    }
    source {
      type = "CODEPIPELINE"
      buildspec = file("buildspec/plan-buildspec.yml")
    }
}
