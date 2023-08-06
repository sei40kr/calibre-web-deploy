variable root_compartment_id {
  type    = string
  default = "ocid1.tenancy.oc1..aaaaaaaatddxamypv2e3hunr4o7be5ymch3pdpml4eculk7zq4bmhk7pnikq"
}

variable "oci_availability_domain" {
  type    = string
  default = "zSzu:AP-TOKYO-1-AD-1"
}

variable "oci_instance_image_id" {
  type    = string
  default = "ocid1.image.oc1.ap-tokyo-1.aaaaaaaac2t4hu43w4fxidje6tou6wu5f5pujjvdyz2prad35hqwynh75akq"
}

variable "budget_amount" {
  type        = string
  default     = "1000"
  description = "Budget amount for Calibre-Web."
}
