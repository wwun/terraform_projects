terraform {
  backend "s3" {
    bucket         = "dev-applications-backend-state-wwun-terraform"
    #el formato para key suele ser: environment / application_name / project_name
    key = "dev/07-backend-state/users/backend-state"
    region = "us-east-1"
    dynamodb_table = "dev_application_locks"
    encrypt = true
  }
}

provider "aws" {
  region = "us-east-1"
}

#v90 step07 creando un recurso IAM
resource "aws_iam_user" "my_iam_user" {
  name = "my_iam_user_abc_updated"
}