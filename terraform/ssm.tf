resource "aws_ssm_parameter" "app_env" {
  name  = "/doc-api/APP_ENV"
  type  = "String"
  value = "dev"

  tags = {
    Name = "doc-api-app-env"
  }
}
