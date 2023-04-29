module "instance" {
  source = "./modules/instance"

  oci_compartment_id                = oci_identity_compartment.calibre_web.id
  oci_availability_domain           = var.available_domain
  oci_vcn_id                        = oci_core_vcn.calibre_web.id
  oci_subnet_id                     = oci_core_subnet.public.id
  oci_instance_image_id             = var.instance_image_id
  nfs_oci_network_security_group_id = module.nfs.oci_nsg_id
}

module "nfs" {
  source = "./modules/nfs"

  oci_compartment_id      = oci_identity_compartment.calibre_web.id
  oci_availability_domain = var.available_domain
  oci_vcn_id              = oci_core_vcn.calibre_web.id
  oci_subnet_id           = oci_core_subnet.private.id
}
