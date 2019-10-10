output "network_id" {
  depends_on	= ["opentelekomcloud_networking_router_interface_v2.tier-3"]
  value 	    = "${opentelekomcloud_networking_network_v2.tier-3.id}"
}
output "frontend_secgrp_id" {
  depends_on  = ["opentelekomcloud_compute_secgroup_v2.frontend"]
  value       = "${opentelekomcloud_compute_secgroup_v2.frontend.id}"
}
output "middleware_secgrp_id" {
  depends_on  = ["opentelekomcloud_compute_secgroup_v2.middleware"]
  value       = "${opentelekomcloud_compute_secgroup_v2.middleware.id}"
}
output "backend_secgrp_id" {
  depends_on  = ["opentelekomcloud_compute_secgroup_v2.backend"]
  value       = "${opentelekomcloud_compute_secgroup_v2.backend.id}"
}
output "vpc_id" {
  depends_on = ["opentelekomcloud_networking_router_v2.tier-3"]
  value      = "${opentelekomcloud_networking_router_v2.tier-3.id}"
}
