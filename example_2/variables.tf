variable "tier-3_instance_flavor_type" {
  default  = "s2.large.2"
}
variable "tier-3_instance_filesystem_size" {
  default = 20
}
variable "tier-3_instance_az" {
  default = "eu-de-01"
}
variable "tier-3_instance_keypair" {
  default= "tsi-key"
}
variable "tier-3_instance_image" {
  default = "Standard_Ubuntu_16.04_latest"
}
variable "tier-3_network_name" {
  default = "tier-3"
}
variable "network_id" {
  default = ""
}
variable "project_name" {
  default = ""
}
variable "postgres_password" {
  default = ""  
}
