# calibre-web-provisioning

Provisioning for [Calibre-Web](https://github.com/janeczku/calibre-web).

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
