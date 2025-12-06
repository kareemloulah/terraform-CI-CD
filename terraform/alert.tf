#######
# VARS
#######
variable "alert_email" {
  description = "Email address to receive CPU alerts"
  type        = string
  default     = "loulahkareem@gmail.com"

}

#############
# Cloud watch
#############
# SNS Topic for CPU Alerts
resource "aws_sns_topic" "cpu_alerts" {
  name = "cpu-utilization-alerts"

  tags = {
    Name        = "CPU Alerts"
    Environment = "production"
  }
}

# SNS Email Subscription
resource "aws_sns_topic_subscription" "cpu_alerts_email" {
  topic_arn = aws_sns_topic.cpu_alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

# CloudWatch Alarm for Frontend Server
resource "aws_cloudwatch_metric_alarm" "frontend_cpu_alarm" {
  alarm_name          = "frontend-high-cpu-alert"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300 # 5 minutes
  statistic           = "Average"
  threshold           = 50
  alarm_description   = "Alert when CPU exceeds 50% on frontend server"
  treat_missing_data  = "notBreaching"

  dimensions = {
    InstanceId = aws_instance.front_server.id
  }

  alarm_actions = [aws_sns_topic.cpu_alerts.arn]
  ok_actions    = [aws_sns_topic.cpu_alerts.arn]
}

# CloudWatch Alarm for Backend Server
resource "aws_cloudwatch_metric_alarm" "backend_cpu_alarm" {
  alarm_name          = "backend-high-cpu-alert"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300 # 5 minutes
  statistic           = "Average"
  threshold           = 50
  alarm_description   = "Alert when CPU exceeds 50% on backend server"
  treat_missing_data  = "notBreaching"

  dimensions = {
    InstanceId = aws_instance.back_server.id
  }

  alarm_actions = [aws_sns_topic.cpu_alerts.arn]
  ok_actions    = [aws_sns_topic.cpu_alerts.arn]
}
##########
# OUTPUTS
##########
output "sns_topic_arn" {
  description = "ARN of the SNS topic for CPU alerts"
  value       = aws_sns_topic.cpu_alerts.arn
}

output "frontend_alarm_name" {
  description = "Name of the frontend CPU alarm"
  value       = aws_cloudwatch_metric_alarm.frontend_cpu_alarm.alarm_name
}

output "backend_alarm_name" {
  description = "Name of the backend CPU alarm"
  value       = aws_cloudwatch_metric_alarm.backend_cpu_alarm.alarm_name
}
