module "network" {
  source = "./modules/network"
  tier-3_network_name	= "${var.tier-3_network_name}"
}

module "compute" {
  source = "./modules/compute"

  tier-3_instance_az			        = "${var.tier-3_instance_az}"
  tier-3_instance_keypair 		    = "${var.tier-3_instance_keypair}"
  tier-3_instance_filesystem_size	= "${var.tier-3_instance_filesystem_size}"
  tier-3_instance_flavor_type		  = "${var.tier-3_instance_flavor_type}"
  tier-3_instance_image			      = "${var.tier-3_instance_image}"
  network_id				              = "${module.network.network_id}"
  project_name                    = "${var.project_name}"

  frontend_secgrp_id              = "${module.network.frontend_secgrp_id}"
  middleware_secgrp_id            = "${module.network.middleware_secgrp_id}"
  backend_secgrp_id               = "${module.network.backend_secgrp_id}"
}
