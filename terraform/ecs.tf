resource "aws_ecs_cluster" "doc_api" {
  name = "doc-api-cluster"
}

resource "aws_ecs_task_definition" "doc_api" {
  family                   = "doc-api-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name      = "doc-api"
      image     = var.docker_image
      essential = true

      portMappings = [
        {
          containerPort = var.app_port
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.app_logs.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "doc-api"
        }
      }

      # Env var from SSM Parameter Store
      secrets = [
        {
          name      = "APP_ENV"
          valueFrom = aws_ssm_parameter.app_env.arn
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "doc_api" {
  name            = "doc-api-service"
  cluster         = aws_ecs_cluster.doc_api.id
  task_definition = aws_ecs_task_definition.doc_api.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [
      aws_subnet.public_a.id,
      aws_subnet.public_b.id
    ]
    security_groups  = [aws_security_group.ecs_tasks.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app_tg.arn
    container_name   = "doc-api"
    container_port   = var.app_port
  }

  depends_on = [aws_lb_listener.http]
}
