#
#  See https://www.terraform.io/intro/getting-started/variables.html for more details.
#
#  Don't change the variables in this file! 
#  Instead, create a terrform.tfvars file to override them.

variable "esxi_hostname" {
  default = "10.0.0.3"
}

variable "esxi_hostport" {
  default = "22"
}

variable "esxi_username" {
  default = "root"
}

variable "esxi_password" { # Unspecified will prompt
}

variable "esxi_datastore" {
  default = "datastore2"
}

variable "vm_network" {
  default = "LAN"
}

variable "hostonly_network" {
  default = "windomain.local"
}

