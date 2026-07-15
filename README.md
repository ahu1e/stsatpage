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

### One-liner (SSH into router)

```sh
curl -sL https://raw.githubusercontent.com/ahu1e/stsatpage/main/install.sh | sh
```

### Interactive menu

```
╔══════════════════════════════════════════╗
║     LuCI Statistics Dashboard           ║
║     CPU · RAM · Network graphs          ║
╚══════════════════════════════════════════╝

  Статус: Не установлен

  Выберите действие:

  1) Установить
  2) Удалить
  3) Обновить
  4) Проверить статус
  5) Выход

  >>>
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
