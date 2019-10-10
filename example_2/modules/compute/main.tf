data "opentelekomcloud_images_image_v2" "os_image" {
  name = "${var.tier-3_instance_image}"
}

data "opentelekomcloud_networking_secgroup_v2" "default_secgroup" {
  name = "sg-${replace(replace(var.project_name, "eu-de_", ""), "_", "")}-default"
}

data "template_file" nginx {
    template = "${file("${path.module}/user_data/nginx.tpl")}"

    vars = {
        middleware_ip = "${opentelekomcloud_compute_instance_v2.middleware.access_ip_v4}"
    }
}

resource "opentelekomcloud_compute_instance_v2" "frontend" {
  name              = "frontend"
  flavor_id         = "${var.tier-3_instance_flavor_type}"
  availability_zone = "${var.tier-3_instance_az}"
  key_pair          = "${var.tier-3_instance_keypair}"
  user_data         = "${data.template_file.nginx.rendered}"
  security_groups   = ["${var.frontend_secgrp_id}",
                       "${data.opentelekomcloud_networking_secgroup_v2.default_secgroup.id}"]

  block_device {
    uuid                  = "${data.opentelekomcloud_images_image_v2.os_image.id}"
    source_type           = "image"
    volume_size           = "${var.tier-3_instance_filesystem_size}"
    boot_index            = 0
    destination_type      = "volume"
    volume_type           = "SATA"
    delete_on_termination = true
  }

  network {
    uuid = "${var.network_id}"
  }
}

resource "opentelekomcloud_compute_instance_v2" "middleware" {
  name              = "middleware"
  flavor_id         = "${var.tier-3_instance_flavor_type}"
  availability_zone = "${var.tier-3_instance_az}"
  key_pair          = "${var.tier-3_instance_keypair}"
  user_data         = "${file("${path.module}/user_data/tomcat.sh")}"
  security_groups   = ["${var.middleware_secgrp_id}",
                       "${data.opentelekomcloud_networking_secgroup_v2.default_secgroup.id}"]

  block_device {
    uuid                  = "${data.opentelekomcloud_images_image_v2.os_image.id}"
    source_type           = "image"
    volume_size           = "${var.tier-3_instance_filesystem_size}"
    boot_index            = 0
    destination_type      = "volume"
    volume_type           = "SATA"
    delete_on_termination = true
  }

  network {
    uuid = "${var.network_id}"
  }
}

resource "opentelekomcloud_rds_instance_v3" "backend" {
  availability_zone = ["eu-de-01"]
  db {
    password = "${var.postgres_password}"
    type = "PostgreSQL"
    version = "9.5"
    port = "5432"
  }
  name = "tier-3_backend_db"
  security_group_id = "${var.backend_secgrp_id}"
  subnet_id = "${var.network_id}"
  vpc_id = "${var.vpc_id}"
  volume {
    type = "COMMON"
    size = 100
  }
  flavor = "rds.pg.c2.medium"
  backup_strategy {
    start_time = "08:00-09:00"
    keep_days = 1
  }
}