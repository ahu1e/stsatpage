# luci-app-statistics-dashboard

Реалтайм-дашборд статистики для OpenWrt 25+ — графики CPU, RAM, сети.

Без зависимости от Lua и git. Использует ucode-шаблоны + shell CGI.

![OpenWrt](https://img.shields.io/badge/OpenWrt-25%2B-brightgreen)

## Установка

```sh
wget -O - https://raw.githubusercontent.com/ahu1e/stsatpage/main/install.sh | sh
```

После установки открой: `http://<ip-роутера>/cgi-bin/luci-statistics-dashboard`

## Удаление

```sh
wget -O - https://raw.githubusercontent.com/ahu1e/stsatpage/main/install.sh | sh -s -- --uninstall
```

## API

| Действие | Описание |
|----------|----------|
| `cpu` | Загрузка по ядрам из `/proc/stat` |
| `ram` | Статистика памяти из `/proc/meminfo` |
| `traffic` | RX/TX байты по интерфейсам из `/sys/class/net` |

Пример: `http://router/cgi-bin/luci-statistics-dashboard?action=cpu`

## Требования

- OpenWrt 24+ с LuCI (ucode)
- `luci-base` (включён по умолчанию)

## Лицензия

MIT
