# AWS Infrastructure Challenges

## Challenge 1: Basic Infrastructure Setup

### Overview
This challenge involves creating a comprehensive infrastructure setup on AWS using Terraform. The goal is to provision the following resources:
- An ECS cluster for containerized application hosting
- An S3 bucket for static file storage
- An RDS instance for database management
- A simple event-driven architecture using SNS for a company-wide topic and SQS for domain-specific subscriptions

### Features Implemented
- **Modular Code**: Separated configuration into ECS, S3, RDS, and messaging modules
- **Parameterization**: Variables for flexibility across environments (e.g., `dev` and `prod`)
- **Security Best Practices**: Secure sensitive data and proper IAM roles
- **Resource Optimization**: Cost-effective instance types and configurations

## Challenge 2: Event-Driven Architecture with Zero Trust

### Overview
This challenge focuses on implementing a secure event-driven architecture using SNS and SQS with zero trust principles and message filtering capabilities.

### Features Implemented
1. **Zero Trust Security**:
   - Explicit allow lists for service principals
   - Account-level restrictions
   - Role-based access control
   - No implicit permissions

2. **Message Filtering**:
   - Filter by message type (e.g., order_created, payment_processed)
   - Message attribute-based filtering
   - Raw message delivery for performance

3. **Enhanced Security**:
   - Server-side encryption for SNS and SQS
   - Dead Letter Queue (DLQ) for failed messages
   - Maximum retry attempts configuration
   - Extended message retention in DLQ

4. **Access Controls**:
   - Separate policies for publish and subscribe
   - Fine-grained IAM conditions
   - Source ARN verification
   - Principal account validation

### Usage Example
```hcl
module "messaging" {
  source = "./modules/messaging"

  topic_name = "company-wide"
  queue_name = "domain-specific"

  # Message filtering
  message_types = [
    "order_created",
    "payment_processed",
    "shipment_updated"
  ]

  # Zero trust configuration
  allowed_sources = [
    "orders-service",
    "payments-service",
    "shipping-service"
  ]

  enable_encryption = true
}
```

### Prerequisites
To complete these challenges, you'll need:
- Terraform installed on your local machine
- An AWS account with appropriate permissions
- AWS CLI configured for authentication

### Development Workflow
1. Initialize the workspace:
   ```bash
   just init
   ```

2. Format and validate:
   ```bash
   just check
   ```

3. Review the plan:
   ```bash
   just show
   ```

4. Generate infrastructure diagrams:
   ```bash
   just graph
   ```

### Security Considerations
- All sensitive data is marked as sensitive in Terraform
- Encryption enabled by default for data at rest
- Zero trust principles applied to all service communications
- Dead letter queues for message failure handling
- Proper IAM roles and policies with least privilege

### Best Practices
- Use of Terraform workspaces for environment separation
- Consistent naming conventions
- Proper tagging strategy
- Infrastructure as Code (IaC) with version control
- Modular and reusable code structure