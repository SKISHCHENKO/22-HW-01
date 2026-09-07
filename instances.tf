#############################################
# Ubuntu 22.04 LTS для тестовых VM
#############################################
data "yandex_compute_image" "ubuntu_2204" {
  family = "ubuntu-2204-lts"
}

#############################################
# NAT-инстанс
# Внутренний IP строго 192.168.10.254
# Image ID строго из условия задания
#############################################
resource "yandex_compute_instance" "nat" {
  name        = "nat-instance"
  hostname    = "nat-instance"
  platform_id = var.vm_platform_id
  zone        = var.zone
  labels      = local.common_labels

  resources {
    cores         = var.vm_cores
    memory        = var.vm_memory
    core_fraction = var.vm_core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = var.nat_image_id
      size     = var.vm_disk_size
      type     = "network-hdd"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public.id
    ip_address         = var.nat_internal_ip
    nat                = true
    security_group_ids = [yandex_vpc_security_group.nat.id]
  }

  metadata = {
    serial-port-enable = "1"
  }
}

#############################################
# Публичная тестовая VM
#############################################
resource "yandex_compute_instance" "public_vm" {
  name        = "public-vm"
  hostname    = "public-vm"
  platform_id = var.vm_platform_id
  zone        = var.zone
  labels      = local.common_labels

  resources {
    cores         = var.vm_cores
    memory        = var.vm_memory
    core_fraction = var.vm_core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_2204.id
      size     = var.vm_disk_size
      type     = "network-hdd"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public.id
    ip_address         = var.public_vm_internal_ip
    nat                = true
    security_group_ids = [yandex_vpc_security_group.public_vm.id]
  }

  metadata = {
    "ssh-keys"          = local.ssh_metadata
    "user-data"         = file("${path.module}/cloud-config.yml")
    "serial-port-enable" = "1"
  }
}

#############################################
# Приватная тестовая VM — без публичного IP
#############################################
resource "yandex_compute_instance" "private_vm" {
  name        = "private-vm"
  hostname    = "private-vm"
  platform_id = var.vm_platform_id
  zone        = var.zone
  labels      = local.common_labels

  resources {
    cores         = var.vm_cores
    memory        = var.vm_memory
    core_fraction = var.vm_core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_2204.id
      size     = var.vm_disk_size
      type     = "network-hdd"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.private.id
    ip_address         = var.private_vm_internal_ip
    nat                = false
    security_group_ids = [yandex_vpc_security_group.private_vm.id]
  }

  metadata = {
    "ssh-keys"          = local.ssh_metadata
    "user-data"         = file("${path.module}/cloud-config.yml")
    "serial-port-enable" = "1"
  }
}
