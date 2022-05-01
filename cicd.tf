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

# 1.b- terraform apply
resource "aws_codebuild_project" "tf-apply" {
    description = "apply stage for terraform"
    name = "tf-cicd-apply"
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
      buildspec = file("buildspec/apply-buildspec.yml")
    }
}

# 2- aws-codepipeline
resource "aws_codepipeline" "cicd-pipeline" {
    name = "tf-cicd"
    role_arn = aws_iam_role.tf-codepipeline-role.arn

    artifact_store {
      type = "S3"
      location = aws_s3_bucket.artifacts.id
    }

    # Source Stage
    stage {
      name = "Source"
      action {
          name = "Source"
          version = "1"
          category = "Source"
          owner = "AWS"
          output_artifacts = ["tf-code"]

          provider = "CodeStarSourceConnection"
          configuration = {
            FullRepositoryId = "timsamanchi-PPS/CICD-TEST-02"
            BranchName = "master"
            ConnectionArn = var.codestar-connector 
            OutputArtifactFormat = "CODE_ZIP"
          }
      }
    }

    # Stage Plan
    stage {
        name = "Plan"
        action {
            name = "Build"
            version = "1"
            category = "Build"
            owner = "AWS"
            input_artifacts = ["tf-code"]

            provider = "CodeBuild"
            configuration = {
              ProjectName = "tf-cicd-plan"
            }
        }
    }

    # Stage Apply
    stage {
        name = "Apply"
        action {
            name = "Build"
            version = "1"
            category = "Build"
            owner = "AWS"
            input_artifacts = ["tf-code"]

            provider = "CodeBuild"
            configuration = {
              ProjectName = "tf-cicd-apply"
            }
        }
    }
}