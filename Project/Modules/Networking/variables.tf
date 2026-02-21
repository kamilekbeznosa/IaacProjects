variable "env" {}
variable "rg_name" {}
variable "location" {}
variable "vnet_cidr" {}
variable "subnet_cidrs" {
    type=map(string)
}