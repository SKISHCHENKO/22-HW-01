output "vpc_id" {
  description = "ID созданной VPC"
  value       = yandex_vpc_network.main.id
}

output "public_subnet" {
  description = "Публичная подсеть"
  value = {
    name = yandex_vpc_subnet.public.name
    cidr = yandex_vpc_subnet.public.v4_cidr_blocks[0]
  }
}

output "private_subnet" {
  description = "Приватная подсеть"
  value = {
    name = yandex_vpc_subnet.private.name
    cidr = yandex_vpc_subnet.private.v4_cidr_blocks[0]
  }
}

output "private_route_next_hop" {
  description = "Next hop для маршрута 0.0.0.0/0 приватной подсети"
  value       = yandex_compute_instance.nat.network_interface[0].ip_address
}

output "nat_internal_ip" {
  description = "Внутренний IP NAT-инстанса"
  value       = yandex_compute_instance.nat.network_interface[0].ip_address
}

output "nat_public_ip" {
  description = "Публичный IP NAT-инстанса"
  value       = yandex_compute_instance.nat.network_interface[0].nat_ip_address
}

output "public_vm_internal_ip" {
  description = "Внутренний IP публичной VM"
  value       = yandex_compute_instance.public_vm.network_interface[0].ip_address
}

output "public_vm_public_ip" {
  description = "Публичный IP публичной VM"
  value       = yandex_compute_instance.public_vm.network_interface[0].nat_ip_address
}

output "private_vm_internal_ip" {
  description = "Внутренний IP приватной VM"
  value       = yandex_compute_instance.private_vm.network_interface[0].ip_address
}

output "ssh_public_vm" {
  description = "Команда SSH на публичную VM"
  value       = "ssh ${var.ssh_user}@${yandex_compute_instance.public_vm.network_interface[0].nat_ip_address}"
}

output "ssh_private_via_public_vm" {
  description = "Команда SSH на private VM через public VM"
  value       = "ssh -J ${var.ssh_user}@${yandex_compute_instance.public_vm.network_interface[0].nat_ip_address} ${var.ssh_user}@${yandex_compute_instance.private_vm.network_interface[0].ip_address}"
}
