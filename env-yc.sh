#!/usr/bin/env bash
# Скрипт нужно именно SOURCE-ить:
#   source ./env-yc.sh
# Тогда export останутся в текущем shell.

set -euo pipefail

command -v yc >/dev/null 2>&1 || {
  echo "Ошибка: Yandex Cloud CLI (yc) не найден в PATH." >&2
  return 1 2>/dev/null || exit 1
}

export YC_TOKEN="$(yc iam create-token)"
export YC_CLOUD_ID="$(yc config get cloud-id)"
export YC_FOLDER_ID="$(yc config get folder-id)"

printf 'YC_CLOUD_ID=%s\n' "$YC_CLOUD_ID"
printf 'YC_FOLDER_ID=%s\n' "$YC_FOLDER_ID"
printf 'YC_TOKEN получен и экспортирован (значение не выводится).\n'
