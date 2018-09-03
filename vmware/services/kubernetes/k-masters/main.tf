provider "vsphere" {
  vsphere_server       = "${var.vsphere_server}"
  allow_unverified_ssl = true
}

resource "vsphere_folder" "k-masters_folder" {
  datacenter_id = "${var.datacenter_id}"
  path          = "k-masters"
  type          = "vm"
}

module "k-master" {
  source             = "../../../modules/services/kubernetes"
  datacenter_id      = "${var.datacenter_id}"
  datastore_name     = "${var.datastore_name}"
  cluster            = "${var.cluster}"
  base_vm_host_name  = "${var.base_vm_host_name}"
  network_name       = "${var.network_name}"
  folder             = "${vsphere_folder.k-masters_folder.path}"
  ansible_playbook   = "${var.ansible_playbook}"
  datacenter         = "${var.datacenter}"
  ipv4_gateway       = "${var.ipv4_gateway}"
  ipv4_netmask       = "${var.ipv4_netmask}"
  ipv4_map           = "${var.ipv4_map}"
  adapter_type       = "${var.adapter_type}"
  num_cpus           = "${var.num_cpus}"
  memory             = "${var.memory}"
  template           = "${var.template}"
  domain             = "${var.domain}"
  count              = "${var.count}"
  dns_server_list    = ["${element(var.dns_server_list, 0)}", "${element(var.dns_server_list, 1)}"]
  region             = "${var.region}"
  env                = "${var.env}"
  init_cluster_state = "${var.init_cluster_state}"
  base_count         = "${var.base_count}"
}
