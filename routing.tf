##### Custom Routes

# Default route to internet (0.0.0.0/0) is automatically created by Google Cloud
# for instances with external IP addresses in public subnets

# Custom route for specific destinations (example)
# Uncomment and modify as needed for your specific routing requirements

# Example: Route to on-premises network via VPN
# resource "google_compute_route" "to_onprem" {
#   name             = "${var.tenant}-${var.name}-route-onprem-${var.environment}"
#   dest_range       = "192.168.0.0/16"
#   network          = google_compute_network.main.name
#   next_hop_gateway = "projects/${var.project_id}/global/gateways/default-internet-gateway"
#   priority         = 1000
#   description      = "Route to on-premises network - Managed by Magicorn"
# }

# Example: Route to another VPC via VPC peering
# resource "google_compute_route" "to_peer_vpc" {
#   name                   = "${var.tenant}-${var.name}-route-peer-${var.environment}"
#   dest_range            = "10.1.0.0/16"
#   network               = google_compute_network.main.name
#   next_hop_vpn_tunnel   = google_compute_vpn_tunnel.tunnel.name
#   priority              = 1000
#   description           = "Route to peered VPC - Managed by Magicorn"
# }

# Example: Custom route via specific instance (for appliances like firewalls)
# resource "google_compute_route" "via_firewall" {
#   name                = "${var.tenant}-${var.name}-route-firewall-${var.environment}"
#   dest_range         = "172.16.0.0/16"
#   network            = google_compute_network.main.name
#   next_hop_instance  = "firewall-instance"
#   next_hop_instance_zone = "${var.region}-a"
#   priority           = 100
#   description        = "Route via firewall appliance - Managed by Magicorn"
# }

# Note: In Google Cloud, most routing is handled automatically:
# 1. Subnet routes are automatically created for each subnet
# 2. Default route (0.0.0.0/0) to internet gateway is automatic for public IPs
# 3. NAT gateway routing is handled by Cloud NAT (configured in nat.tf)
# 4. Custom routes are only needed for specific scenarios like:
#    - VPN connections
#    - VPC peering
#    - Custom network appliances
#    - Specific routing policies