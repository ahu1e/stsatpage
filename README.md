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

SSH into router and run:

```sh
wget https://raw.githubusercontent.com/ahu1e/stsatpage/main/install.sh
sh install.sh
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

## Usage

- **LuCI menu**: Services → Statistics Dashboard

## API

The CGI backend exposes these endpoints:

| Action | Description |
|--------|-------------|
| `?action=cpu` | CPU stats per core |
| `?action=ram` | Memory usage |
| `?action=traffic` | Network bytes per interface |

## License

MIT
