##### Create VPC
resource "google_compute_network" "main" {
  name                    = "${var.tenant}-${var.name}-vpc-${var.environment}"
  auto_create_subnetworks = false
  routing_mode            = var.routing_mode
  description             = "Managed by Magicorn"

  # Google Cloud doesn't support tags on VPC networks directly
  # Labels are used instead
}

# Create a project-level metadata for tracking
resource "google_compute_project_metadata_item" "vpc_tags" {
  key = "${var.tenant}-${var.name}-vpc-${var.environment}-tags"
  value = jsonencode({
    Name        = "${var.tenant}-${var.name}-vpc-${var.environment}"
    Tenant      = var.tenant
    Project     = var.name
    Environment = var.environment
    Maintainer  = "Magicorn"
    Terraform   = "yes"
  })
}
