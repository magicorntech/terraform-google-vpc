##### Create Public Subnets
resource "google_compute_subnetwork" "pbl" {
  count         = length(var.pbl_sub_count)
  name          = "${var.tenant}-${var.name}-snet-pbl-${var.pbl_sub_count[count.index].zone}-${var.environment}"
  ip_cidr_range = var.pbl_sub_count[count.index].cidr
  region        = coalesce(var.pbl_sub_count[count.index].region, data.google_client_config.current.region)
  network       = google_compute_network.main.id
  description   = "Managed by Magicorn"

  # Enable private Google access for better connectivity
  private_ip_google_access = true
}

##### Create Private Subnets
resource "google_compute_subnetwork" "pvt" {
  count         = length(var.pvt_sub_count)
  name          = "${var.tenant}-${var.name}-snet-pvt-${var.pvt_sub_count[count.index].zone}-${var.environment}"
  ip_cidr_range = var.pvt_sub_count[count.index].cidr
  region        = coalesce(var.pvt_sub_count[count.index].region, data.google_client_config.current.region)
  network       = google_compute_network.main.id
  description   = "Managed by Magicorn"

  # Enable private Google access for better connectivity
  private_ip_google_access = true

  # Secondary IP ranges for GKE pods and services
  secondary_ip_range {
    range_name    = var.pvt_sub_count[count.index].region != null ? "gke-pods-${var.pvt_sub_count[count.index].region}" : "gke-pods"
    ip_cidr_range = var.gke_pod_count[count.index].cidr
  }

  secondary_ip_range {
    range_name    = var.pvt_sub_count[count.index].region != null ? "gke-services-${var.pvt_sub_count[count.index].region}" : "gke-services"
    ip_cidr_range = var.gke_svc_count[count.index].cidr
  }
}

##### Create Database Subnets
resource "google_compute_subnetwork" "db" {
  count         = length(var.db_sub_count)
  name          = "${var.tenant}-${var.name}-snet-db-${var.db_sub_count[count.index].zone}-${var.environment}"
  ip_cidr_range = var.db_sub_count[count.index].cidr
  region        = coalesce(var.db_sub_count[count.index].region, data.google_client_config.current.region)
  network       = google_compute_network.main.id
  description   = "Managed by Magicorn"

  # Enable private Google access for better connectivity
  private_ip_google_access = true
}