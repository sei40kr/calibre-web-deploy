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

resource "oci_core_subnet" "private" {
  cidr_block     = "10.0.1.0/24"
  compartment_id = oci_identity_compartment.calibre_web.id
  vcn_id         = oci_core_vcn.calibre_web.id
}
