resource "oci_file_storage_export" "nfs" {
  export_set_id  = oci_file_storage_export_set.nfs.id
  file_system_id = oci_file_storage_file_system.nfs.id
  path           = "/calibre-web-books"
}

resource "oci_file_storage_file_system" "nfs" {
  availability_domain = var.oci_availability_domain
  compartment_id      = var.oci_compartment_id

  display_name = "calibre-web-books"
}

resource "oci_file_storage_export_set" "nfs" {
  mount_target_id = oci_file_storage_mount_target.nfs.id
}

resource "oci_file_storage_mount_target" "nfs" {
  availability_domain = var.oci_availability_domain
  compartment_id      = var.oci_compartment_id
  subnet_id           = var.oci_subnet_id

  display_name = "calibre-web-books"
  ip_address   = "10.0.1.101"
  nsg_ids      = [oci_core_network_security_group.mount_target.id]
}
