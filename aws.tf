provider "aws" {
  version = "~> 2.30"
  region  = "us-east-1"
  # It doesn't matter and we don't care!
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_route53_zone" "zone" {
  count = var.enable_aws ? 1 : 0
  name  = var.root_domain
}

resource "aws_route53_record" "a_records" {
  depends_on = [aws_route53_zone.zone]
  for_each   = var.enable_aws ? var.a_records : {}
  zone_id    = aws_route53_zone.zone[0].zone_id
  name       = each.key
  type       = "A"
  ttl        = var.ttl
  records    = each.value
}

resource "aws_route53_record" "cname_records" {
  depends_on = [aws_route53_zone.zone]
  for_each   = var.enable_aws ? var.cname_records : {}
  zone_id    = aws_route53_zone.zone[0].zone_id
  name       = each.key
  type       = "CNAME"
  records    = [each.value]
  ttl        = var.ttl
}

resource "aws_route53_record" "txt_records" {
  depends_on = [aws_route53_zone.zone]
  for_each   = var.enable_aws ? var.txt_records : {}
  zone_id    = aws_route53_zone.zone[0].zone_id
  name       = each.key
  type       = "TXT"
  records    = [each.value]
  ttl        = var.ttl
}

resource "aws_route53_record" "mx_records" {
  depends_on = [aws_route53_zone.zone]
  for_each   = var.enable_aws ? var.mx_records : {}
  zone_id    = aws_route53_zone.zone[0].zone_id
  name       = each.key
  type       = "MX"
  records    = [each.value]
  ttl        = var.ttl
}
