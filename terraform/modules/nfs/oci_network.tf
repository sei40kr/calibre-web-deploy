resource "oci_core_network_security_group" "client" {
  compartment_id = var.oci_compartment_id
  vcn_id         = var.oci_vcn_id
}

resource "oci_core_network_security_group" "mount_target" {
  compartment_id = var.oci_compartment_id
  vcn_id         = var.oci_vcn_id
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
