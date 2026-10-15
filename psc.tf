# Global addresses for all managed service blocks
resource "google_compute_global_address" "managed_services" {
  for_each      = { for block in var.managed_service_blocks : block.name => block }
  name          = "${var.tenant}-${var.name}-vpc-${var.environment}-${each.value.name}-private-ip"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = tonumber(split("/", each.value.cidr)[1])
  address       = split("/", each.value.cidr)[0]
  network       = google_compute_network.main.self_link
  project       = data.google_project.current.project_id

  labels = {
    name        = "${var.tenant}-${var.name}-vpc-${var.environment}-${each.value.name}-private-ip"
    tenant      = var.tenant
    project     = var.name
    environment = var.environment
    maintainer  = "magicorn"
    terraform   = "yes"
  }
}

# Create private services connection (only for blocks with psc = true)
resource "google_service_networking_connection" "main" {
  count   = length(var.reserved_peering_ranges) > 0 || length([for block in var.managed_service_blocks : block if block.psc == true]) > 0 ? 1 : 0
  network = google_compute_network.main.self_link
  service = "servicenetworking.googleapis.com"
  reserved_peering_ranges = concat(
    var.reserved_peering_ranges,
    [for block in var.managed_service_blocks : google_compute_global_address.managed_services[block.name].name if block.psc == true]
  )
}