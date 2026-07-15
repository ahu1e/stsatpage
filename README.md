# luci-app-statistics-dashboard

Реалтайм-дашборд статистики для OpenWrt 25+ — графики CPU, RAM, сети.

Без зависимости от Lua. Использует ucode-шаблоны + shell CGI.

![OpenWrt](https://img.shields.io/badge/OpenWrt-25%2B-brightgreen)

## Установка на роутер

Одной командой:

```sh
wget -O - https://raw.githubusercontent.com/ahu1e/stsatpage/main/install.sh | sh
```

Или склонировать и запустить:

```sh
git clone https://github.com/ahu1e/stsatpage.git
cd stsatpage
sh install.sh
```

После установки открой: `http://<ip-роутера>/cgi-bin/luci-statistics-dashboard`

## Ручная установка

```sh
scp ucode/template/statistics-dashboard/dashboard.ut root@router:/usr/share/luci/template/statistics-dashboard/
scp root/usr/share/luci/menu.d/luci-app-statistics-dashboard.json root@router:/usr/share/luci/menu.d/
scp root/www/cgi-bin/luci-statistics-dashboard root@router:/www/cgi-bin/
ssh root@router "chmod +x /www/cgi-bin/luci-statistics-dashboard && /etc/init.d/uhttpd restart"
```

## Удаление

```sh
rm -f /www/cgi-bin/luci-statistics-dashboard
rm -f /usr/share/luci/menu.d/luci-app-statistics-dashboard.json
rm -rf /usr/share/luci/template/statistics-dashboard
/etc/init.d/uhttpd restart
```

## API

CGI-эндпоинт предоставляет:

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
