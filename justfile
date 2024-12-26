# List available commands
default:
    @just --list

# Initialize Terraform
init:
    terraform init

# Format Terraform files
fmt:
    terraform fmt -recursive

# Validate Terraform configuration
validate:
    terraform validate

# Show current plan
plan:
    terraform plan -out=tfplan

# Show the plan in a more readable format
show: plan
    terraform show tfplan

# Generate infrastructure graphs in multiple formats
graph:
    terraform graph | dot -Tpng > infrastructure.png
    terraform graph | dot -Tsvg > infrastructure.svg
    terraform graph | dot -Tpdf > infrastructure.pdf
    @echo "Generated infrastructure diagrams in PNG, SVG, and PDF formats"

# Clean up generated files
clean:
    rm -f tfplan infrastructure.{png,svg,pdf}
    rm -rf .terraform
    rm -f .terraform.lock.hcl
    rm -f terraform.tfstate*

# Full check: format, validate, and plan
check: fmt validate plan

# Apply the Terraform plan
apply:
    terraform apply tfplan

# Destroy all resources
destroy:
    terraform destroy 