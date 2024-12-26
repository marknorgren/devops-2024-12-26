terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment = var.environment
      Project     = "aws-infrastructure-challenge"
      ManagedBy   = "terraform"
    }
  }
}

# ECS Cluster
resource "aws_ecs_cluster" "main" {
  name = "${var.project_name}-${var.environment}"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

# S3 Bucket
resource "aws_s3_bucket" "static_files" {
  bucket = "${var.project_name}-${var.environment}-static-files"
}

resource "aws_s3_bucket_versioning" "static_files" {
  bucket = aws_s3_bucket.static_files.id
  versioning_configuration {
    status = "Enabled"
  }
}

# RDS Instance
resource "aws_db_instance" "main" {
  identifier        = "${var.project_name}-${var.environment}"
  engine            = "postgres"
  engine_version    = "14"
  instance_class    = "db.t3.micro"
  allocated_storage = 20

  db_name  = "appdb"
  username = var.db_username
  password = var.db_password

  skip_final_snapshot = true
}

# SNS Topic
resource "aws_sns_topic" "company_wide" {
  name = "${var.project_name}-${var.environment}-company-wide"
}

# SQS Queue
resource "aws_sqs_queue" "domain_specific" {
  name = "${var.project_name}-${var.environment}-domain-specific"
}

# SNS Topic Subscription
resource "aws_sns_topic_subscription" "domain_subscription" {
  topic_arn = aws_sns_topic.company_wide.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.domain_specific.arn
}

# SQS Queue Policy
resource "aws_sqs_queue_policy" "domain_specific" {
  queue_url = aws_sqs_queue.domain_specific.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "sns.amazonaws.com"
        }
        Action   = "sqs:SendMessage"
        Resource = aws_sqs_queue.domain_specific.arn
        Condition = {
          ArnEquals = {
            "aws:SourceArn" : aws_sns_topic.company_wide.arn
          }
        }
      }
    ]
  })
} 