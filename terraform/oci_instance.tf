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
  compartment_id      = oci_identity_compartment.calibre_web.id
  create_vnic_details {
    assign_public_ip = true
    nsg_ids = [
      oci_core_network_security_group.instance.id,
      oci_core_network_security_group.client.id
    ]
    subnet_id = oci_core_subnet.public.id
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

resource "oci_core_network_security_group" "instance" {
  compartment_id = oci_identity_compartment.calibre_web.id
  vcn_id         = oci_core_vcn.calibre_web.id
}

# Calibre-Web uses port 8083 and this can be changed only in the web interface.
resource "oci_core_network_security_group_security_rule" "instance_http_default" {
  direction                 = "INGRESS"
  network_security_group_id = oci_core_network_security_group.instance.id
  protocol                  = "6"
  source                    = "0.0.0.0/0"
  source_type               = "CIDR_BLOCK"
  stateless                 = false
  tcp_options {
    destination_port_range {
      max = 8083
      min = 8083
    }
  }
}

resource "oci_core_network_security_group_security_rule" "instance_http" {
  direction                 = "INGRESS"
  description               = "Allow HTTP. Necessary for certbot to verify domain ownership."
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

resource "oci_core_network_security_group_security_rule" "instance_https" {
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
