#############################################
# Новая пустая VPC
#############################################
resource "yandex_vpc_network" "main" {
  name        = var.network_name
  description = "Netology homework: public/private subnets with NAT instance"
  labels      = local.common_labels
}

#############################################
# Публичная подсеть 192.168.10.0/24
#############################################
resource "yandex_vpc_subnet" "public" {
  name           = "public"
  description    = "Public subnet for public VM and NAT instance"
  zone           = var.zone
  network_id     = yandex_vpc_network.main.id
  v4_cidr_blocks = [var.public_subnet_cidr]
}

#############################################
# Route table приватной подсети.
# Весь трафик 0.0.0.0/0 отправляется на NAT VM.
#############################################
resource "yandex_vpc_route_table" "private" {
  name        = "private-route-table"
  description = "Default route from private subnet through NAT instance"
  network_id  = yandex_vpc_network.main.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = yandex_compute_instance.nat.network_interface[0].ip_address
  }
}

#############################################
# Приватная подсеть 192.168.20.0/24
#############################################
resource "yandex_vpc_subnet" "private" {
  name           = "private"
  description    = "Private subnet routed to NAT instance"
  zone           = var.zone
  network_id     = yandex_vpc_network.main.id
  v4_cidr_blocks = [var.private_subnet_cidr]
  route_table_id = yandex_vpc_route_table.private.id
}
