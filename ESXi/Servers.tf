#########################################
#  ESXI Provider host/login details
#########################################
#
#   Use of variables here to hide/move the variables to a separate file
#
provider "esxi" {
  esxi_hostname = var.esxi_hostname
  esxi_hostport = var.esxi_hostport
  esxi_username = var.esxi_username
  esxi_password = var.esxi_password
}

#########################################
#  ESXI Guest resource
#########################################

resource "esxi_guest" "dc" {
  guest_name = "dc"
  disk_store = var.esxi_datastore
  guestos    = "windows9srv-64"

  boot_disk_type = "thin"

  memsize            = "8192"
  numvcpus           = "4"
  resource_pool_name = "/"
  power              = "on"
  clone_from_vm = "LAB_CLONER_WindowsServer2016"
  # This is the network that bridges your host machine with the ESXi VM
#  network_interfaces {
#    virtual_network = var.vm_network
#    mac_address     = "00:50:56:a1:b1:c2"
#    nic_type        = "e1000"
#  }
  # This is the local network that will be used for Kaiju.local addressing
  network_interfaces {
    virtual_network = var.hostonly_network
    mac_address     = "00:50:56:a1:b1:c4"
    nic_type        = "e1000"
  }
  guest_startup_timeout  = 45
  guest_shutdown_timeout = 30
}

resource "esxi_guest" "exchange" {
  guest_name = "exchange"
  disk_store = var.esxi_datastore
  guestos    = "windows9srv-64"

  boot_disk_type = "thin"

  memsize            = "16384"
  numvcpus           = "4"
  resource_pool_name = "/"
  power              = "on"
  clone_from_vm = "LAB_CLONER_WindowsServer2016"
  # This is the network that bridges your host machine with the ESXi VM
#  network_interfaces {
#    virtual_network = var.vm_network
#    mac_address     = "00:50:56:a1:b2:c5"
#    nic_type        = "e1000"
#  }
  # This is the local network that will be used for 192.168.38.x addressing
  network_interfaces {
    virtual_network = var.hostonly_network
    mac_address     = "00:50:56:a1:b4:c5"
    nic_type        = "e1000"
  }
  guest_startup_timeout  = 45
  guest_shutdown_timeout = 30
}

resource "esxi_guest" "kit" {
  guest_name = "kit"
  disk_store = var.esxi_datastore
  guestos    = "ubuntu-64"

  boot_disk_type = "thin"

  memsize            = "8192"
  numvcpus           = "4"
  resource_pool_name = "/"
  power              = "on"
  clone_from_vm = "LAB_CLONER_Ubuntu2004"

    provisioner "remote-exec" {
    inline = [
      "sudo ifconfig eth0 up && echo 'eth0 up' || echo 'unable to bring eth0 interface up",
      "sudo ifconfig eth1 up && echo 'eth1 up' || echo 'unable to bring eth1 interface up",
      "sudo ifconfig eth2 up && echo 'eth2 up' || echo 'unable to bring eth2 interface up",
      "sudo ifconfig eth3 up && echo 'eth3 up' || echo 'unable to bring eth3 interface up"
    ]

    connection {
      host        = self.ip_address
      type        = "ssh"
      user        = "vagrant"
      password    = "vagrant"
    }
  }
  network_interfaces {
    virtual_network = var.vm_wan
    mac_address     = "00:50:58:a1:b1:c1"
    nic_type        = "e1000"
  }
  network_interfaces {
    virtual_network = var.vm_network
    mac_address     = "00:50:58:a1:b1:c2"
    nic_type        = "e1000"
  }
  network_interfaces {
    virtual_network = var.hostonly_network
    mac_address     = "00:50:58:a1:b1:c3"
    nic_type        = "e1000"
  }
  network_interfaces {
    virtual_network = var.red_space
    mac_address     = "00:50:58:a1:b1:c4"
    nic_type        = "e1000"
  }
  guest_startup_timeout  = 45
  guest_shutdown_timeout = 30
}
