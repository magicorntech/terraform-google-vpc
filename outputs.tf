output "vpc_id" {
  description = "ID of the VPC"
  value       = google_compute_network.main.id
}

output "vpc_name" {
  description = "Name of the VPC"
  value       = google_compute_network.main.name
}

output "vpc_self_link" {
  description = "Self link of the VPC"
  value       = google_compute_network.main.self_link
}

# Multi-cloud consistent naming (for compatibility with other providers)
output "pbl_subnet_ids" {
  description = "List of public subnet IDs"
  value       = google_compute_subnetwork.pbl[*].id
}

output "pvt_subnet_ids" {
  description = "List of private subnet IDs"
  value       = google_compute_subnetwork.pvt[*].id
}

output "gke_pod_secondary_range_names" {
  description = "The names of the GKE pod secondary IP ranges"
  value       = [for subnet in google_compute_subnetwork.pvt : subnet.secondary_ip_range[0].range_name]
}

output "gke_svc_secondary_range_names" {
  description = "The names of the GKE service secondary IP ranges"
  value       = [for subnet in google_compute_subnetwork.pvt : subnet.secondary_ip_range[1].range_name]
}

output "db_subnet_ids" {
  description = "List of database subnet IDs"
  value       = google_compute_subnetwork.db[*].id
}

# NAT Gateway Outputs
output "nat_gateway_id" {
  description = "ID of the NAT gateway"
  value       = length(google_compute_router_nat.main) > 0 ? google_compute_router_nat.main[0].id : null
}

output "router_id" {
  description = "ID of the Cloud Router"
  value       = length(google_compute_router.main) > 0 ? google_compute_router.main[0].id : null
}

output "router_name" {
  description = "Name of the Cloud Router"
  value       = length(google_compute_router.main) > 0 ? google_compute_router.main[0].name : null
}

output "cidr_block" {
  description = "CIDR block of the VPC"
  value       = var.cidr_block
}

output "managed_service_blocks" {
  description = "Managed service blocks with both list and map access"
  value = {
    list = var.managed_service_blocks[*].cidr
    map = {
      for block in var.managed_service_blocks : block.name => {
        cidr         = block.cidr
        psc          = block.psc
        address_name = google_compute_global_address.managed_services[block.name].name
      }
    }
  }
}

output "managed_service_global_addresses" {
  description = "Global addresses created for managed service blocks"
  value = {
    for name, addr in google_compute_global_address.managed_services : name => {
      name      = addr.name
      address   = addr.address
      cidr      = "${addr.address}/${addr.prefix_length}"
      self_link = addr.self_link
    }
  }
}
