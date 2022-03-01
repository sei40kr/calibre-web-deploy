variable root_compartment_id {
  type    = string
  default = "ocid1.tenancy.oc1..aaaaaaaatddxamypv2e3hunr4o7be5ymch3pdpml4eculk7zq4bmhk7pnikq"
}

variable available_domain {
  type    = string
  default = "zSzu:AP-TOKYO-1-AD-1"
}

variable instance_image_id {
  type    = string
  default = "ocid1.image.oc1.ap-tokyo-1.aaaaaaaac2t4hu43w4fxidje6tou6wu5f5pujjvdyz2prad35hqwynh75akq"
}

variable instance_ssh_authorized_keys {
  type    = string
  default = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILdPlt1yisJ1BaoaJRrhlltk/rbqYcMAY9PHJRx4jAsg sei40kr@nixos"
}