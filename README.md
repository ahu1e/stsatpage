# luci-app-statistics-dashboard

Real-time statistics dashboard for OpenWrt 25+ — CPU load, memory usage, and network traffic graphs.

## Features

- **CPU usage** — per-core and total load graphs
- **Memory** — RAM usage with used/free/buffers/cached breakdown
- **Network traffic** — RX/TX bytes per active interface
- **Dark mode** toggle with localStorage persistence
- **Real-time polling** every 2 seconds

## Requirements

- OpenWrt 24+ (ucode-based LuCI)
- `luci-base` (no Lua dependency)

## Install

### Quick install (via SSH)

```sh
git clone https://github.com/ahu1e/stsatpage.git
cd stsatpage
chmod +x install.sh
./install.sh root@192.168.1.1
```

### Manual install

```sh
# Copy files to router
scp root/www/cgi-bin/luci-statistics-dashboard root@router:/www/cgi-bin/
scp ucode/template/statistics-dashboard/dashboard.ut root@router:/usr/share/luci/template/statistics-dashboard/
scp root/usr/share/luci/menu.d/luci-app-statistics-dashboard.json root@router:/usr/share/luci/menu.d/

# Set permissions and restart
ssh root@router "chmod +x /www/cgi-bin/luci-statistics-dashboard && /etc/init.d/uhttpd restart"
```

### Build as OpenWrt package

```sh
# Copy to OpenWrt feeds
cp -r luci-app-statistics-dashboard /path/to/openwrt/feeds/luci/applications/

# Build
cd /path/to/openwrt
./scripts/feeds update luci
make package/luci-app-statistics-dashboard/compile V=s
```

## Usage

- **LuCI menu**: Status → Statistics → Dashboard
- **Direct URL**: `http://router/cgi-bin/luci-statistics-dashboard`

## API

The CGI backend exposes these endpoints:

| Action | Description |
|--------|-------------|
| `?action=cpu` | CPU stats per core |
| `?action=ram` | Memory usage |
| `?action=traffic` | Network bytes per interface |

## License

MIT
