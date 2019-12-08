variable "a_records" {
  type    = map(map(string))
  default = {}
}

variable "cname_records" {
  type    = map(list(string))
  default = {}
}