resource "tls_private_key" "ssh" {
  algorithm = "ED25519"
}

resource "oci_core_instance" "instance" {
  agent_config {
    is_management_disabled = true
  }
  availability_config {
    is_live_migration_preferred = true
  }
  availability_domain = var.oci_availability_domain
  compartment_id      = var.oci_compartment_id
  create_vnic_details {
    assign_public_ip = true
    nsg_ids          = [oci_core_network_security_group.instance.id, var.nfs_oci_network_security_group_id]
    subnet_id        = var.oci_subnet_id
  }
  metadata = {
    ssh_authorized_keys = tls_private_key.ssh.public_key_openssh
  }
  shape = "VM.Standard.A1.Flex"
  shape_config {
    baseline_ocpu_utilization = "BASELINE_1_1"
    memory_in_gbs             = 12
    ocpus                     = 2
  }
  source_details {
    boot_volume_size_in_gbs = 50
    source_id               = var.oci_instance_image_id
    source_type             = "image"
  }
}
