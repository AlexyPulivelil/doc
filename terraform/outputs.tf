output "alb_dns_name" {
  description = "Public URL of the Application Load Balancer"
  value       = aws_lb.app_alb.dns_name
}
