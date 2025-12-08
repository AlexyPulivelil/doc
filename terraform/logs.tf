resource "aws_cloudwatch_log_group" "app_logs" {
  name              = "/ecs/doc-api"
  retention_in_days = 7
}
