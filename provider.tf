# Аутентификация выполняется через переменные окружения:
# YC_TOKEN, YC_CLOUD_ID, YC_FOLDER_ID.
# Их удобно получить из уже настроенного профиля Yandex Cloud CLI:
# source ./env-yc.sh
provider "yandex" {
  zone = var.zone
}
