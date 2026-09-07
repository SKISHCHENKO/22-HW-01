variable "zone" {
  description = "Зона доступности Yandex Cloud"
  type        = string
  default     = "ru-central1-a"
}

variable "network_name" {
  description = "Имя новой VPC"
  type        = string
  default     = "hw-nat-vpc"
}

variable "public_subnet_cidr" {
  description = "CIDR публичной подсети"
  type        = string
  default     = "192.168.10.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR приватной подсети"
  type        = string
  default     = "192.168.20.0/24"
}

variable "nat_internal_ip" {
  description = "Фиксированный внутренний IP NAT-инстанса по условию задания"
  type        = string
  default     = "192.168.10.254"
}

variable "public_vm_internal_ip" {
  description = "Фиксированный внутренний IP публичной тестовой ВМ"
  type        = string
  default     = "192.168.10.10"
}

variable "private_vm_internal_ip" {
  description = "Фиксированный внутренний IP приватной тестовой ВМ"
  type        = string
  default     = "192.168.20.10"
}

variable "nat_image_id" {
  description = "Image ID NAT-инстанса из условия домашнего задания"
  type        = string
  default     = "fd80mrhj8fl2oe87o4e1"
}

variable "ssh_user" {
  description = "Пользователь ОС для Ubuntu VM"
  type        = string
  default     = "ubuntu"
}

variable "ssh_public_key" {
  description = "Публичный SSH-ключ для подключения к тестовым VM"
  type        = string
}

variable "vm_platform_id" {
  description = "Платформа виртуальных машин"
  type        = string
  default     = "standard-v3"
}

variable "vm_cores" {
  description = "Количество vCPU тестовых VM и NAT-инстанса"
  type        = number
  default     = 2
}

variable "vm_memory" {
  description = "Объём RAM в ГБ"
  type        = number
  default     = 2
}

variable "vm_core_fraction" {
  description = "Гарантированная доля vCPU, %"
  type        = number
  default     = 20
}

variable "vm_disk_size" {
  description = "Размер загрузочного диска в ГБ"
  type        = number
  default     = 10
}
