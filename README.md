# luci-app-statistics-dashboard

Realtime statistics dashboard for OpenWrt 25+ — CPU, RAM, Network graphs.

No Lua dependency. Uses ucode templates + shell CGI.

![preview](https://img.shields.io/badge/OpenWrt-25%2B-brightgreen)

## Install on router

One command:

```sh
wget -O - https://raw.githubusercontent.com/ahu1e/stsatpage/main/install.sh | sh
```

Or clone + run:

```sh
git clone https://github.com/ahu1e/stsatpage.git
cd stsatpage
sh install.sh
```

After install open: `http://<router-ip>/cgi-bin/luci-statistics-dashboard`

## Manual install

```sh
scp ucode/template/statistics-dashboard/dashboard.ut root@router:/usr/share/luci/template/statistics-dashboard/
scp root/usr/share/luci/menu.d/luci-app-statistics-dashboard.json root@router:/usr/share/luci/menu.d/
scp root/www/cgi-bin/luci-statistics-dashboard root@router:/www/cgi-bin/
ssh root@router "chmod +x /www/cgi-bin/luci-statistics-dashboard && /etc/init.d/uhttpd restart"
```

## Uninstall

```sh
rm -f /www/cgi-bin/luci-statistics-dashboard
rm -f /usr/share/luci/menu.d/luci-app-statistics-dashboard.json
rm -rf /usr/share/luci/template/statistics-dashboard
/etc/init.d/uhttpd restart
```

## API

The CGI endpoint exposes:

| Action | Description |
|--------|-------------|
| `cpu` | Per-core CPU usage from `/proc/stat` |
| `ram` | Memory stats from `/proc/meminfo` |
| `traffic` | RX/TX bytes per interface from `/sys/class/net` |

Example: `http://router/cgi-bin/luci-statistics-dashboard?action=cpu`

## Requirements

- OpenWrt 24+ with LuCI (ucode)
- `luci-base` (included by default)

## License

MIT
