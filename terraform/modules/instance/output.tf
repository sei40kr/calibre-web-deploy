output "public_ip" {
  value = oci_core_instance.instance.public_ip
}

output "public_key_openssh" {
  value = tls_private_key.ssh.public_key_openssh
}

output "private_key_openssh" {
  value = tls_private_key.ssh.private_key_openssh
}