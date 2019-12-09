variable "root_domain" {
  type = string
}

variable "a_records" {
  type    = map(list(string))
  default = {}
}

variable "cname_records" {
  type    = map(string)
  default = {}
}

variable "txt_records" {
  type    = map(string)
  default = {}
}

variable "mx_records" {
  type    = map(string)
  default = {}
}

variable "ttl" {
  type    = number
  default = 300
}

variable "soa_email" {
  type    = string
  default = ""
}

# Provider enable flags
variable "enable_aws" {
  type    = bool
  default = false
}
variable "enable_linode" {
  type    = bool
  default = false
}
variable "enable_scaleway" {
  type    = bool
  default = false
}

# AWS Variables
variable "aws_access_key" {
  type    = string
  default = ""
}
variable "aws_secret_key" {
  type    = string
  default = ""
}

# Scaleway variables
variable "scaleway_access_key" {
  type    = string
  default = ""
}
variable "scaleway_secret_key" {
  type    = string
  default = ""
}

# Linode variables
variable "linode_token" {
  type    = string
  default = ""
}

# Internally consumed

locals {
  a_records = flatten([for domain, ips in var.a_records : [for ip in ips : {
    domain = domain
    ip     = ip
  }]])
}
