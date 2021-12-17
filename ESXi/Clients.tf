#########################################
#  ESXI Guest Extended resource
#########################################

resource "esxi_guest" "win10-1" {
  guest_name = "win10-1"
  disk_store = var.esxi_datastore
  guestos    = "windows9-64"

  boot_disk_type = "thin"

  memsize            = "4096"
  numvcpus           = "2"
  resource_pool_name = "/"
  power              = "on"
  clone_from_vm = "LAB_CLONER_Windows10"
  # This is the network that bridges your host machine with the ESXi VM
  network_interfaces {
    virtual_network = var.vm_network
    mac_address     = "00:50:56:a2:b1:c2"
    nic_type        = "e1000"
  }
  # This is the local network that will be used for Kaiju.local addressing
  network_interfaces {
    virtual_network = var.hostonly_network
    mac_address     = "00:50:56:a2:b1:c4"
    nic_type        = "e1000"
  }
  guest_startup_timeout  = 45
  guest_shutdown_timeout = 30
}
