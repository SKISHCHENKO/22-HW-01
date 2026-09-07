#############################################
# Security Group NAT-инстанса
#############################################
resource "yandex_vpc_security_group" "nat" {
  name        = "nat-instance-sg"
  description = "Allow forwarding from private subnet and outbound Internet access"
  network_id  = yandex_vpc_network.main.id

  # Трафик, который приходит от VM из private subnet и должен быть маршрутизирован наружу.
  ingress {
    protocol       = "ANY"
    description    = "Traffic from private subnet"
    v4_cidr_blocks = [var.private_subnet_cidr]
  }

  # SSH оставлен для диагностики NAT-инстанса во время выполнения ДЗ.
  ingress {
    protocol       = "TCP"
    description    = "SSH for diagnostics"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol       = "ANY"
    description    = "Outbound Internet"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

#############################################
# Security Group публичной VM
#############################################
resource "yandex_vpc_security_group" "public_vm" {
  name        = "public-vm-sg"
  description = "SSH access to public test VM"
  network_id  = yandex_vpc_network.main.id

  ingress {
    protocol       = "TCP"
    description    = "SSH from Internet"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol       = "ANY"
    description    = "Any outbound traffic"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

#############################################
# Security Group приватной VM
#############################################
resource "yandex_vpc_security_group" "private_vm" {
  name        = "private-vm-sg"
  description = "SSH only from public subnet; outbound traffic via NAT instance"
  network_id  = yandex_vpc_network.main.id

  # При ssh -J соединение до private VM приходит с внутреннего IP public VM.
  ingress {
    protocol       = "TCP"
    description    = "SSH from public subnet"
    port           = 22
    v4_cidr_blocks = [var.public_subnet_cidr]
  }

  egress {
    protocol       = "ANY"
    description    = "Outbound through route table and NAT instance"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}
