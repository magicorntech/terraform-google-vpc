variable "tenant" {
  description = "Tenant name"
  type        = string
}

variable "name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

variable "cidr_block" {
  description = "CIDR block for the VPC (not used in GCP, but kept for compatibility)"
  type        = string
  default     = "10.0.0.0/16"
}

variable "routing_mode" {
  description = "Routing mode for the VPC (REGIONAL or GLOBAL)"
  type        = string
  default     = "REGIONAL"
}

variable "nat_gateway" {
  description = "Whether to create NAT gateway (regional, high-availability by default)"
  type        = bool
  default     = true
}

variable "pbl_sub_count" {
  description = "List of public subnets with CIDR, zone, and optional region"
  type = list(object({
    cidr   = string
    zone   = string
    region = optional(string)
  }))
  default = []
}

variable "pvt_sub_count" {
  description = "List of private subnets with CIDR, zone, and optional region"
  type = list(object({
    cidr   = string
    zone   = string
    region = optional(string)
  }))
  default = []
}

variable "gke_pod_count" {
  description = "List of GKE pod subnets with CIDR, zone, and optional region"
  type = list(object({
    cidr   = string
    zone   = string
    region = optional(string)
  }))
  default = []
}

variable "gke_svc_count" {
  description = "List of GKE service subnets with CIDR, zone, and optional region"
  type = list(object({
    cidr   = string
    zone   = string
    region = optional(string)
  }))
  default = []
}

variable "db_sub_count" {
  description = "List of database subnets with CIDR, zone, and optional region"
  type = list(object({
    cidr   = string
    zone   = string
    region = optional(string)
  }))
  default = []
}

variable "reserved_peering_ranges" {
  description = "List of reserved peering ranges"
  type        = list(string)
  default     = []
}

variable "managed_service_blocks" {
  description = "List of managed service blocks"
  type = list(object({
    name = string
    cidr = string
    psc  = bool
  }))
  default = []
}