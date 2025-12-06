# AWS Infrastructure & Deployment Setup

This project automates the provisioning of AWS infrastructure, monitoring, and deployment for a sample application using Terraform and GitHub Actions.

## Features

- **VPC & Subnets**: Configures a VPC with public and private subnets.
- **EC2 Instances**: Deploys frontend and backend servers with SSH access.
- **RDS Database**: MySQL instance in private subnets with a dedicated DB subnet group.
- **Security Groups**: Fine-grained rules for frontend, backend, and DB instances.
- **CloudWatch Monitoring**: CPU utilization alarms for both frontend and backend servers.
- **SNS Notifications**: Email alerts for CPU thresholds.
- **Key Pair**: Generates a private key for EC2 SSH access.
- **GitHub Actions**: Automated deployment of frontend and backend apps via SSH.

## Terraform Variables

- `alert_email`: Email to receive CPU alerts (default: `loulahkareem@gmail.com`).
- `aws_region`: AWS region for deployment (default: `eu-west-2`).
- `availability_zone-0` / `availability_zone-1`: Public and private AZs.

## Outputs

- `sns_topic_arn`: ARN of the SNS topic for CPU alerts.
- `frontend_alarm_name`: Name of frontend CPU alarm.
- `backend_alarm_name`: Name of backend CPU alarm.
- `ssh`: SSH commands for accessing frontend, backend, and RDS instances.

## Deployment

1. **Terraform Setup**
   ```bash
   terraform init
   terraform plan
   terraform apply
