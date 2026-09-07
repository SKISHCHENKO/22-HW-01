#!/usr/bin/env bash
set -euo pipefail

SSH_USER="${SSH_USER:-ubuntu}"
SSH_KEY="${SSH_KEY:-$HOME/.ssh/id_ed25519}"

PUBLIC_IP="$(terraform output -raw public_vm_public_ip)"
PRIVATE_IP="$(terraform output -raw private_vm_internal_ip)"
NAT_PUBLIC_IP="$(terraform output -raw nat_public_ip)"
NAT_INTERNAL_IP="$(terraform output -raw nat_internal_ip)"
NEXT_HOP="$(terraform output -raw private_route_next_hop)"

SSH_OPTS=(
  -i "$SSH_KEY"
  -o StrictHostKeyChecking=accept-new
  -o ConnectTimeout=10
)

echo "[1/5] Проверка адреса NAT-инстанса"
echo "NAT internal IP: $NAT_INTERNAL_IP"
if [[ "$NAT_INTERNAL_IP" != "192.168.10.254" ]]; then
  echo "ОШИБКА: NAT должен иметь 192.168.10.254" >&2
  exit 1
fi

echo
echo "[2/5] Проверка next hop приватной route table"
echo "Route next hop: $NEXT_HOP"
if [[ "$NEXT_HOP" != "$NAT_INTERNAL_IP" ]]; then
  echo "ОШИБКА: next hop не совпадает с IP NAT-инстанса" >&2
  exit 1
fi

echo
echo "[3/5] Интернет с public-vm ($PUBLIC_IP)"
PUBLIC_EGRESS="$(ssh "${SSH_OPTS[@]}" "$SSH_USER@$PUBLIC_IP" 'curl -4 -sS --max-time 15 https://ifconfig.co/ip' | tr -d '\r\n')"
echo "Public VM egress IP: $PUBLIC_EGRESS"

echo
echo "[4/5] SSH на private-vm ($PRIVATE_IP) через public-vm ($PUBLIC_IP)"
PRIVATE_EGRESS="$(ssh "${SSH_OPTS[@]}" \
  -o "ProxyCommand=ssh -i $SSH_KEY -o StrictHostKeyChecking=accept-new -o ConnectTimeout=10 -W %h:%p $SSH_USER@$PUBLIC_IP" \
  "$SSH_USER@$PRIVATE_IP" \
  'curl -4 -sS --max-time 15 https://ifconfig.co/ip' | tr -d '\r\n')"
echo "Private VM egress IP: $PRIVATE_EGRESS"

echo
echo "[5/5] Сравнение egress private-vm с публичным IP NAT"
echo "NAT public IP:       $NAT_PUBLIC_IP"
echo "Private VM egress:   $PRIVATE_EGRESS"

if [[ "$PRIVATE_EGRESS" == "$NAT_PUBLIC_IP" ]]; then
  echo "OK: private-vm выходит в Интернет через NAT-инстанс."
else
  echo "ОШИБКА: private-vm вышла в Интернет не через ожидаемый NAT IP." >&2
  exit 1
fi
