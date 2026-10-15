# terraform-google-vpc

Magicorn made Terraform Module for Google Cloud Provider
--
```
module "vpc" {
  source      = "magicorntech/vpc/google"
  version     = "0.0.1"
  tenant      = var.tenant
  name        = var.name
  environment = var.environment

  # VPC Configuration
  cidr_block   = "10.0.0.0/12"
  routing_mode = "GLOBAL"
  nat_gateway  = true

  # Subnet Mapping
  pbl_sub_count = [
    { cidr = "10.7.0.0/21", zone = "a" }
  ]
  pvt_sub_count = [
    { cidr = "10.7.16.0/21", zone = "a" },
    { cidr = "10.8.16.0/21", zone = "b" }
  ]
  gke_pod_count = [
    { cidr = "10.7.128.0/17", zone = "a" },
    { cidr = "10.8.128.0/17", zone = "b" }
  ]
  gke_svc_count = [
    { cidr = "10.7.32.0/21", zone = "a" },
    { cidr = "10.8.32.0/21", zone = "b" }
  ]
  db_sub_count = [
    { cidr = "10.7.48.0/21", zone = "a" }
  ]

  # Managed Service Blocks
  managed_service_blocks = [
    {
      name = "sql"
      cidr = "192.168.238.0/24"
      psc  = true
    },
    {
      name = "redis"
      cidr = "192.168.234.0/24"
      psc  = true
    }
  ]
}
```

## Notes
1) GKE pod/service CIDRs are secondary ranges on private subnets, index-aligned with `pvt_sub_count`. Names are `gke-pods` / `gke-services` (or `gke-pods-<region>` when a subnet `region` is set). Pass those to the GKE module via `gke_pod_secondary_range_names` and `gke_svc_secondary_range_names`.
2) `nat_gateway = true` creates one regional Cloud NAT on private subnets. Public subnets use external IPs.
3) `managed_service_blocks` with `psc = true` reserve a global internal address and attach it to Private Service Access (`servicenetworking.googleapis.com`) for Cloud SQL / Memorystore.
4) Project ID and region come from the Google provider. Set `region` on a subnet only to place it outside the provider region.
