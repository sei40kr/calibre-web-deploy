resource "oci_core_vcn" "calibre_web" {
  compartment_id = oci_identity_compartment.calibre_web.id
  cidr_block     = "10.0.0.0/16"
}

resource "oci_core_internet_gateway" "calibre_web" {
  compartment_id = oci_identity_compartment.calibre_web.id
  enabled        = true
  vcn_id         = oci_core_vcn.calibre_web.id
}

resource "oci_core_route_table" "igw" {
  compartment_id = oci_identity_compartment.calibre_web.id
  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.calibre_web.id
  }
  vcn_id = oci_core_vcn.calibre_web.id
}

resource "oci_core_subnet" "public" {
  cidr_block     = "10.0.0.0/24"
  compartment_id = oci_identity_compartment.calibre_web.id
  route_table_id = oci_core_route_table.igw.id
  vcn_id         = oci_core_vcn.calibre_web.id
}

resource "oci_core_network_security_group" "instance" {
  compartment_id = oci_identity_compartment.calibre_web.id
  vcn_id         = oci_core_vcn.calibre_web.id
}

resource "oci_core_network_security_group_security_rule" "http" {
  direction                 = "INGRESS"
  network_security_group_id = oci_core_network_security_group.instance.id
  protocol                  = "6"
  source                    = "0.0.0.0/0"
  source_type               = "CIDR_BLOCK"
  stateless                 = false
  tcp_options {
    destination_port_range {
      max = 80
      min = 80
    }
  }
}

resource "oci_core_network_security_group_security_rule" "https" {
  direction                 = "INGRESS"
  network_security_group_id = oci_core_network_security_group.instance.id
  protocol                  = "6"
  source                    = "0.0.0.0/0"
  source_type               = "CIDR_BLOCK"
  stateless                 = false

  tcp_options {
    destination_port_range {
      max = 443
      min = 443
    }
  }
}

resource "tls_private_key" "ssh" {
  algorithm = "ED25519"
}

resource "oci_core_instance" "calibre_web" {
  agent_config {
    is_management_disabled = true
  }
  availability_config {
    is_live_migration_preferred = true
  }
  availability_domain = var.available_domain
  compartment_id      = oci_identity_compartment.calibre_web.id
  create_vnic_details {
    assign_public_ip = true
    nsg_ids          = [oci_core_network_security_group.instance.id]
    subnet_id        = oci_core_subnet.public.id
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
    source_id               = var.instance_image_id
    source_type             = "image"
  }
}

resource "local_file" "ssh_private_key" {
  filename = "../ssh-keys/id_ed25519"

  content         = tls_private_key.ssh.private_key_openssh
  file_permission = "600"
}

resource "local_file" "ssh_public_key" {
  filename = "../ssh-keys/id_ed25519.pub"

  content = tls_private_key.ssh.public_key_openssh
}
