variable "oci_compartment_id" {
  type = string
}

variable "oci_availability_domain" {
  type    = string
  default = "zSzu:AP-TOKYO-1-AD-1"
}

variable "oci_vcn_id" {
  type = string
}

variable "oci_subnet_id" {
  type = string
}

variable "nfs_oci_network_security_group_id" {
  type = string
}

variable "oci_instance_image_id" {
  type    = string
  default = "ocid1.image.oc1.ap-tokyo-1.aaaaaaaac2t4hu43w4fxidje6tou6wu5f5pujjvdyz2prad35hqwynh75akq"
}
