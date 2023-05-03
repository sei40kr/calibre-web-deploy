# calibre-web-provisioning

Provisioning for [Calibre-Web](https://github.com/janeczku/calibre-web).

## Prerequisites

- [Terraform](https://www.terraform.io)
- [Ansible](https://www.ansible.com)

## Usage

First, run the following command in `/terraform` to initialize the Terraform environment:

```sh
terraform init
```

Then, run the following command in `/terraform` to create the infrastructure:

```sh
terraform apply
```

This will create a pair of SSH keys in `/ssh-keys`.

Finally, run the following command in `/ansible` to provision the instance:

```sh
ansible-playbook --ask-vault-password \
                 -i inventory \
                 --private-key ../ssh-keys/id_ed25519 \
                 defaults/main.yml
```

You might need to wait for a few minutes for the instance and the DNS record to
be ready.

If you have any trouble, you can run the following command to enter the
instance via SSH:

```sh
ssh -i ssh-keys/id_ed25519 ubuntu@calibre-web.yong-ju.me
```

## Architecture

Calibre-Web is hosted on an OCI compute instance. The instance is in a public
subnet and has a public IP address. The instance is accessible from the
internet.
AWS Route53 binds the domain name to the instance's public IP address.

Calibre books will be stored on OCI file storage. The mount target is in a
private subnet. The file storage is mounted on the compute instance. The data
in the file storage is cached on the compute instance's volume.

The certificate is obtained from Let's Encrypt using certbot. It is **NOT**
renewed automatically. We need to manually renew the certificate before it
expires.
