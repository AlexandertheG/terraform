variable "vsphere_user" {
  default = ""
}

variable "vsphere_pass" {
  default = ""
}

variable "vsphere_server" {
  default = "<vsphere_server>"
}

variable "dns_server_list" {
  default = ["192.168.7.11", "192.168.7.12"]
}

variable "ipv4_gateway" {
  default = "192.168.7.1"
}

variable "network_name" {
  default = "<your_vlan>"
}

variable "ipv4_netmask" {
  default = 24
}

variable "num_cpus" {
  default = 4
}

variable "memory" {
  default = 16384
}

variable "template" {
  default = "<path_to_atomic_centos_vm_template>"
  type = "string"
}

variable "datastore_name" {
  default = "<datastore_name>"
}

variable "domain" {
  default = "<your_domain_dot_local>"
}

variable "count" {
  default = 3
}

variable "datacenter" {
  default = "<datacenter_find_in_vsphere>"
}

variable "datacenter_id" {
  default = "<datacenter_id>"
}

variable "cluster" {
  default = "<cluster>"
}

variable "ipv4_map" {
  default = {
      "1" = "192.168.7.21",
      "2" = "192.168.7.22",
      "3" = "192.168.7.23"
    }
}

variable "adapter_type" {
  default = "vmxnet3"
}

variable "base_vm_host_name" {
  default = "k-master"
}

variable "ansible_playbook" {
  default = "k_masters"
}


variable "base_count" {
  default = "1"
}

variable "init_cluster_state" {

}
