resource "opentelekomcloud_networking_router_v2" "tier-3" {
  name             = "tier-3-vpc"
  admin_state_up   = "true"
  external_gateway = "0a2228f2-7f8a-45f1-8e09-9039e1d09975"
  enable_snat	     = "true"
}

resource "opentelekomcloud_networking_network_v2" "tier-3" {
  name           = "${var.tier-3_network_name}"
  admin_state_up = "true"
}

resource "opentelekomcloud_networking_subnet_v2" "tier-3" {
  name            = "tier-3-internal-subnet"
  network_id      = "${opentelekomcloud_networking_network_v2.tier-3.id}"
  cidr            = "192.168.10.0/24"
  ip_version      = 4
  dns_nameservers = ["8.8.8.8", "8.8.4.4"]
}

resource "opentelekomcloud_networking_router_interface_v2" "tier-3" {
  router_id = "${opentelekomcloud_networking_router_v2.tier-3.id}"
  subnet_id = "${opentelekomcloud_networking_subnet_v2.tier-3.id}"
}

# Frontend SecGroup and Rule
resource "opentelekomcloud_compute_secgroup_v2" "frontend" {
  name        = "frontend-secgrp"
  description = "Frontend Security Group"

  rule {
    from_port       = 443
    to_port         = 443
    ip_protocol     = "tcp"
    cidr            = "0.0.0.0/0"
  }

  rule {
    from_port       = 80
    to_port         = 80
    ip_protocol     = "tcp"
    cidr            = "0.0.0.0/0"
  }

  rule {
    from_port       = -1
    to_port         = -1
    ip_protocol     = "icmp"
    cidr            = "0.0.0.0/0"
  }
}

# Middleware SecGroup and Rule
resource "opentelekomcloud_compute_secgroup_v2" "middleware" {
  name        = "middleware-secgrp"
  description = "Middleware Security Group"

  rule {
    from_port       = 8443
    to_port         = 8443
    ip_protocol     = "tcp"
    from_group_id   = "${opentelekomcloud_compute_secgroup_v2.frontend.id}"
  }

  rule {
    from_port       = 8080
    to_port         = 8080
    ip_protocol     = "tcp"
    from_group_id   = "${opentelekomcloud_compute_secgroup_v2.frontend.id}"
  }
}

# Backend SecGroup and Rule
resource "opentelekomcloud_compute_secgroup_v2" "backend" {
  name        = "backend-secgrp"
  description = "Backend Security Group"

  rule {
    from_port       = 5432
    to_port         = 5432
    ip_protocol     = "tcp"
    from_group_id   = "${opentelekomcloud_compute_secgroup_v2.middleware.id}"
  }
}