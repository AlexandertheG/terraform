data "vsphere_virtual_machine" "template" {
  name          = "${var.template}"
  datacenter_id = "${var.datacenter_id}"
}

data "vsphere_resource_pool" "pool" {
  name          = "${var.cluster}/Resources"
  datacenter_id = "${var.datacenter_id}"
}

data "vsphere_datastore" "datastore" {
  name          = "${var.datastore_name}"
  datacenter_id = "${var.datacenter_id}"
}

data "vsphere_network" "network" {
  name          = "${var.network_name}"
  datacenter_id = "${var.datacenter_id}"
}


resource "vsphere_virtual_machine" "k-vm" {
  guest_id               = "centos64Guest"
  datastore_id           = "${data.vsphere_datastore.datastore.id}"
  resource_pool_id       = "${data.vsphere_resource_pool.pool.id}"
  folder                 = "${var.folder}"
  count                  = "${var.count}"
  name                   = "${var.base_vm_host_name}${count.index + var.base_count}.${var.domain}"
  num_cpus               = "${var.num_cpus}"
  memory                 = "${var.memory}"
  sync_time_with_host    = true
  memory_hot_add_enabled = true

  lifecycle {
    ignore_changes = ["*", "clone.0.template_uuid"]
  }

  network_interface {
    network_id   = "${data.vsphere_network.network.id}"
    adapter_type = "${var.adapter_type}"
  }

  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"

    customize {
      dns_server_list = "${var.dns_server_list}"

      linux_options {
        host_name = "${var.base_vm_host_name}${count.index + var.base_count}"
        domain    = "${var.domain}"
      }

      network_interface {
        ipv4_address = "${lookup(var.ipv4_map, count.index + var.base_count)}"
        ipv4_netmask = "${var.ipv4_netmask}"
      }
      ipv4_gateway = "${var.ipv4_gateway}"
    }
  }

  # /dev/sda
  disk {
    unit_number  = 0
    size         = 16
    label         = "${var.base_vm_host_name}${count.index + var.base_count}.${var.domain}.vmdk"
    disk_sharing = "sharingNone"
    thin_provisioned = false
    eagerly_scrub = true
  }

  # /dev/sdb
  disk {
    unit_number   = 1
    size          = "${var.sdb_size}"
    label         = "${var.base_vm_host_name}${count.index + var.base_count}-extra1.${var.domain}.vmdk"
    datastore_id  = "${data.vsphere_datastore.datastore.id}"
    disk_sharing  = "sharingNone"
    thin_provisioned = false
    eagerly_scrub = true
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "root"
      private_key = "${file("~/.ssh/terraform-template.pem")}"
      agent       = false
      timeout     = "30s"
    }

    inline = [
      "hostnamectl set-hostname ${var.base_vm_host_name}${count.index + var.base_count}.${var.domain}",
      "echo ${var.base_vm_host_name}${count.index + var.base_count}.${var.domain} > /etc/hostname",
      "vmware-toolbox-cmd timesync enable",
      "sed -ire 's/SELINUX=enforcing/SELINUX=permissive/' /etc/selinux/config",
      "setenforce 0"
    ]
  }

  provisioner "local-exec" {
    command = "sleep 5; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i '${lookup(var.ipv4_map, count.index + var.base_count)},' ${path.module}/ansible/${var.ansible_playbook}.yml --private-key ~/.ssh/terraform-template.pem --user=root --extra-vars 'k_count=${count.index} init_cluster_state=${var.init_cluster_state}' --extra-vars '{\"dns_server_list\": [${join(",", var.dns_server_list)}]}' --vault-password-file ${path.module}/ansible/vars/vault_pass"
  }
}
