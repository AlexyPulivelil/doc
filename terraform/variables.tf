variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "ap-south-1"
}

variable "docker_image" {
  description = "Docker image from Docker Hub"
  type        = string
}

variable "app_port" {
  description = "Container listening port"
  type        = number
  default     = 8000
}
