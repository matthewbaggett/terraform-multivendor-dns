provider "linode" {
  version = "~> 1.9.0"
  token   = var.linode_token
}

locals {
  a_records = flatten([
    for domain, ips in var.a_records : [
      for ip in ips : {
        domain = domain
        ip     = ip
      }
    ]
  ])
}

output "a_records" {
  value = local.a_records
}

output "cname_records" {
  value = var.cname_records
}

resource "linode_domain" "zone" {
  count     = var.enable_linode ? 1 : 0
  domain    = var.root_domain
  type      = "master"
  soa_email = var.soa_email
  ttl_sec   = var.ttl
}

resource "linode_domain_record" "a_record" {
  count       = var.enable_linode ? length(local.a_records) : 0
  domain_id   = linode_domain.zone[0].id
  name        = local.a_records[count.index].domain
  record_type = "A"
  target      = local.a_records[count.index].ip
  ttl_sec     = var.ttl
}

resource "linode_domain_record" "cname_record" {
  for_each    = var.enable_linode ? var.cname_records : {}
  domain_id   = linode_domain.zone[0].id
  name        = each.key
  record_type = "CNAME"
  target      = each.value
  ttl_sec     = var.ttl
}

resource "linode_domain_record" "txt_record" {
  for_each    = var.enable_linode ? var.txt_records : {}
  domain_id   = linode_domain.zone[0].id
  name        = each.key
  record_type = "TXT"
  target      = each.value
  ttl_sec     = var.ttl
}

resource "linode_domain_record" "mx_record" {
  for_each    = var.enable_linode ? var.mx_records : {}
  domain_id   = linode_domain.zone[0].id
  name        = each.key
  record_type = "CNAME"
  target      = each.value
  ttl_sec     = var.ttl
}
