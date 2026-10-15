##### Create Cloud Router for NAT Gateway
resource "google_compute_router" "main" {
  count   = var.nat_gateway == true ? 1 : 0
  name    = "${var.tenant}-${var.name}-router-${var.environment}"
  region  = data.google_client_config.current.region
  network = google_compute_network.main.id

  description = "Managed by Magicorn"
}

##### Create NAT Gateway (Regional, High-Availability by default)
resource "google_compute_router_nat" "main" {
  count  = var.nat_gateway == true ? 1 : 0
  name   = "${var.tenant}-${var.name}-natgw-${var.environment}"
  router = google_compute_router.main[0].name
  region = data.google_client_config.current.region

  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  # NAT for private subnets
  dynamic "subnetwork" {
    for_each = google_compute_subnetwork.pvt
    content {
      name                    = subnetwork.value.id
      source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
    }
  }

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }

  depends_on = [google_compute_router.main]
}
