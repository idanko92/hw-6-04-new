variable "flow" {
  type    = string
  default = "24-01"
}

variable "cloud_id" {
  type    = string
  default = "b1g2fl4o3thjvse8pe8b"
}
variable "folder_id" {
  type    = string
  default = "b1g2e12v9aa60j0kdcit"
}

variable "test" {
  type = map(number)
  default = {
    cores         = 2
    memory        = 1
    core_fraction = 20
  }
}

