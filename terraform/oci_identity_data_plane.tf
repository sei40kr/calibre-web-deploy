resource "oci_identity_compartment" "calibre_web" {
  compartment_id = var.root_compartment_id
  description    = "Calibre-Web"
  name           = "calibre-web"
}
