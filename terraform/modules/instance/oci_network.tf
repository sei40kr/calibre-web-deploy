resource "oci_core_network_security_group" "instance" {
  compartment_id = var.oci_compartment_id
  vcn_id         = var.oci_vcn_id
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
