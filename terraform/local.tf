resource "local_file" "ssh_private_key" {
  filename = "../ssh-keys/id_ed25519"

  content         = module.instance.private_key_openssh
  file_permission = "600"
}

resource "local_file" "ssh_public_key" {
  filename = "../ssh-keys/id_ed25519.pub"

  content = module.instance.public_key_openssh
}
