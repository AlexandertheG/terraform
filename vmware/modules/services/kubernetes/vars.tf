variable "network_name" {
  description = "VLAN"
}

variable "ipv4_gateway" {
  description = "VLAN/net IPv4 GW"
}

variable "ipv4_netmask" {
  description = "IPv4 network bit length e.g. 23, 24"
}

variable "num_cpus" {
  description = "Number of CPU's"
}

variable "memory" {
  description = "Memory (in megabytes)"
}

variable "template" {
  description = "Template from which to create a VM"
}

variable "datastore_name" {
  description = "Datastore ID for VM"
}

variable "datacenter_id" {
  description = "Datacenter ID for VM"
}

variable "cluster" {
  description = "Cluster Name"
}

variable "domain" {
  description = "FQDN used to construct hostname and VM name e.g. dev.foo.local"
}

variable "count" {
  description = "Number of VM's to spin up. Also appended to VM names to distinguish them in the same cluster."
}

variable "dns_server_list" {
  description = "DNS resolvers"
  type = "list"
}

variable "datacenter" {
 description = "Datacenter"
}

variable "folder" {
  description = "Folder in which to place a VM"
}

variable "ansible_playbook" {
  description = "Ansible playbook name to play"
}

variable "ipv4_map" {
  type = "map"
}

variable "adapter_type" {
  description = "Network Adapter Type"
}

variable "base_vm_host_name" {
  description = "Base name before the number, e.g. k-master"
}


variable "base_count" {
  description = "Number of the first VM"
}

variable "init_cluster_state" {
  description = "Initial etcd cluster state"
}

variable "sdb_size" {
  default = "100"
}
