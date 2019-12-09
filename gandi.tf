provider "gandi" {
  key = var.gandi_key
}

data "gandi_zone" "zone" {
  count = var.enable_gandi ? 1 : 0
  name  = var.root_domain
}

resource "gandi_zonerecord" "a_records" {
  depends_on = [data.gandi_zone.zone]
  for_each   = var.enable_gandi ? var.a_records : {}
  zone       = data.gandi_zone.zone[0].id
  name       = each.key == "" ? "@" : each.key
  type       = "A"
  ttl        = var.ttl
  values     = each.value
}

resource "gandi_zonerecord" "cname_records" {
  depends_on = [data.gandi_zone.zone]
  for_each   = var.enable_gandi ? var.cname_records : {}
  zone       = data.gandi_zone.zone[0].id
  name       = each.key == "" ? "@" : each.key
  type       = "CNAME"
  ttl        = var.ttl
  values     = [each.value]
}

resource "gandi_zonerecord" "txt_records" {
  depends_on = [data.gandi_zone.zone]
  for_each   = var.enable_gandi ? var.txt_records : {}
  zone       = data.gandi_zone.zone[0].id
  name       = each.key == "" ? "@" : each.key
  type       = "TXT"
  ttl        = var.ttl
  values     = [each.value]
}

resource "gandi_zonerecord" "mx_records" {
  depends_on = [data.gandi_zone.zone]
  for_each   = var.enable_gandi ? var.mx_records : {}
  zone       = data.gandi_zone.zone[0].id
  name       = each.key == "" ? "@" : each.key
  type       = "A"
  ttl        = var.ttl
  values     = [each.value]
}