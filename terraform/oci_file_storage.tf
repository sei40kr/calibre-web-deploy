resource "oci_file_storage_export" "nfs" {
  export_set_id  = oci_file_storage_export_set.nfs.id
  file_system_id = oci_file_storage_file_system.nfs.id
  path           = "/calibre-web-books"
}

resource "oci_file_storage_file_system" "nfs" {
  availability_domain = var.oci_availability_domain
  compartment_id      = oci_identity_compartment.calibre_web.id

  display_name = "calibre-web-books"
}

resource "oci_file_storage_export_set" "nfs" {
  mount_target_id = oci_file_storage_mount_target.nfs.id
}

resource "oci_file_storage_mount_target" "nfs" {
  availability_domain = var.oci_availability_domain
  compartment_id      = oci_identity_compartment.calibre_web.id
  subnet_id           = oci_core_subnet.private.id

  display_name = "calibre-web-books"
  ip_address   = "10.0.1.101"
  nsg_ids      = [oci_core_network_security_group.mount_target.id]
}

resource "oci_core_network_security_group" "mount_target" {
  compartment_id = oci_identity_compartment.calibre_web.id
  vcn_id         = oci_core_vcn.calibre_web.id
}

resource "oci_core_network_security_group_security_rule" "server_tcp_ingress" {
  for_each = toset(["111", "2048", "2049", "2050"])

  direction                 = "INGRESS"
  network_security_group_id = oci_core_network_security_group.mount_target.id
  protocol                  = "6"

  source      = oci_core_network_security_group.client.id
  source_type = "NETWORK_SECURITY_GROUP"
  stateless   = false
  tcp_options {
    destination_port_range {
      max = tonumber(each.value)
      min = tonumber(each.value)
    }
  }
}

resource "oci_core_network_security_group_security_rule" "server_udp_ingress" {
  for_each = toset(["111", "2048"])

  direction                 = "INGRESS"
  network_security_group_id = oci_core_network_security_group.mount_target.id
  protocol                  = "17"

  source      = oci_core_network_security_group.client.id
  source_type = "NETWORK_SECURITY_GROUP"
  stateless   = false
  udp_options {
    destination_port_range {
      max = tonumber(each.value)
      min = tonumber(each.value)
    }
  }
}

resource "oci_core_network_security_group_security_rule" "server_tcp_egress" {
  for_each = toset(["111", "2048", "2049", "2050"])

  direction                 = "EGRESS"
  network_security_group_id = oci_core_network_security_group.mount_target.id
  protocol                  = "6"

  destination      = oci_core_network_security_group.client.id
  destination_type = "NETWORK_SECURITY_GROUP"
  stateless        = false
  tcp_options {
    source_port_range {
      max = tonumber(each.value)
      min = tonumber(each.value)
    }
  }
}

resource "oci_core_network_security_group_security_rule" "server_udp_egress" {
  direction                 = "EGRESS"
  network_security_group_id = oci_core_network_security_group.mount_target.id
  protocol                  = "17"

  destination      = oci_core_network_security_group.client.id
  destination_type = "NETWORK_SECURITY_GROUP"
  stateless        = false
  udp_options {
    source_port_range {
      min = 111
      max = 111
    }
  }
}

resource "oci_core_network_security_group" "client" {
  compartment_id = oci_identity_compartment.calibre_web.id
  vcn_id         = oci_core_vcn.calibre_web.id
}

resource "oci_core_network_security_group_security_rule" "client_tcp_ingress" {
  for_each = toset(["111", "2048", "2049", "2050"])

  direction                 = "INGRESS"
  network_security_group_id = oci_core_network_security_group.client.id
  protocol                  = "6"

  source      = "${oci_file_storage_mount_target.nfs.ip_address}/32"
  source_type = "CIDR_BLOCK"
  stateless   = false
  tcp_options {
    source_port_range {
      max = tonumber(each.value)
      min = tonumber(each.value)
    }
  }
}

resource "oci_core_network_security_group_security_rule" "client_udp_ingress" {
  direction                 = "INGRESS"
  network_security_group_id = oci_core_network_security_group.client.id
  protocol                  = "17"

  source      = "${oci_file_storage_mount_target.nfs.ip_address}/32"
  source_type = "CIDR_BLOCK"
  stateless   = false
  udp_options {
    source_port_range {
      max = 111
      min = 111
    }
  }
}

resource "oci_core_network_security_group_security_rule" "client_tcp_egress" {
  for_each = toset(["111", "2048", "2049", "2050"])

  direction                 = "EGRESS"
  network_security_group_id = oci_core_network_security_group.client.id
  protocol                  = "6"

  destination      = "${oci_file_storage_mount_target.nfs.ip_address}/32"
  destination_type = "CIDR_BLOCK"
  stateless        = false
  tcp_options {
    destination_port_range {
      max = tonumber(each.value)
      min = tonumber(each.value)
    }
  }
}

resource "oci_core_network_security_group_security_rule" "client_udp_egress" {
  for_each = toset(["111", "2048"])

  direction                 = "EGRESS"
  network_security_group_id = oci_core_network_security_group.client.id
  protocol                  = "17"

  destination      = "${oci_file_storage_mount_target.nfs.ip_address}/32"
  destination_type = "CIDR_BLOCK"
  stateless        = false
  udp_options {
    destination_port_range {
      max = tonumber(each.value)
      min = tonumber(each.value)
    }
  }
}
