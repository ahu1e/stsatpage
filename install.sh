#!/bin/sh

set -e

REPO="https://github.com/ahu1e/stsatpage"
ARCHIVE="$REPO/archive/refs/heads/main.tar.gz"
TMPDIR="/tmp/luci-app-statistics-dashboard"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

[ "$(id -u)" = "0" ] || { printf "${RED}Запусти от root!${NC}\n"; exit 1; }

do_install() {
	printf "${BLUE}[1/5]${NC} Скачивание...\n"
	rm -rf "$TMPDIR"
	mkdir -p "$TMPDIR"
	wget -q -O - "$ARCHIVE" | tar xz -C "$TMPDIR"
	SRC=$(find "$TMPDIR" -maxdepth 1 -type d | tail -1)

	printf "${BLUE}[2/5]${NC} Установка шаблона...\n"
	mkdir -p /usr/share/luci/template/statistics-dashboard
	cp "$SRC/ucode/template/statistics-dashboard/dashboard.ut" \
	   /usr/share/luci/template/statistics-dashboard/

	printf "${BLUE}[3/5]${NC} Установка меню...\n"
	mkdir -p /usr/share/luci/menu.d
	cp "$SRC/root/usr/share/luci/menu.d/luci-app-statistics-dashboard.json" \
	   /usr/share/luci/menu.d/

	printf "${BLUE}[4/5]${NC} Установка CGI API...\n"
	mkdir -p /www/cgi-bin
	cp "$SRC/root/www/cgi-bin/luci-statistics-dashboard" /www/cgi-bin/
	chmod +x /www/cgi-bin/luci-statistics-dashboard

	printf "${BLUE}[5/5]${NC} Перезапуск uhttpd...\n"
	/etc/init.d/uhttpd restart

	rm -rf "$TMPDIR"

	echo ""
	printf "${GREEN}Готово!${NC} Открой LuCI: Services → Statistics Dashboard\n"
}

do_uninstall() {
	printf "${BLUE}[1/3]${NC} Удаление файлов...\n"
	rm -f /www/cgi-bin/luci-statistics-dashboard
	rm -f /usr/share/luci/menu.d/luci-app-statistics-dashboard.json
	rm -rf /usr/share/luci/template/statistics-dashboard

	printf "${BLUE}[2/3]${NC} Перезапуск uhttpd...\n"
	/etc/init.d/uhttpd restart

	printf "${BLUE}[3/3]${NC} ${GREEN}Готово!${NC} Пакет удалён.\n"
}

do_update() {
	rm -f /www/cgi-bin/luci-statistics-dashboard
	rm -f /usr/share/luci/menu.d/luci-app-statistics-dashboard.json
	rm -rf /usr/share/luci/template/statistics-dashboard

	printf "${YELLOW}Обновление...${NC}\n"
	do_install
}

do_status() {
	if [ -f /www/cgi-bin/luci-statistics-dashboard ]; then
		printf "${GREEN}Установлен${NC}\n"
	else
		printf "${RED}Не установлен${NC}\n"
	fi
}

# ── Pipe mode: автоустановка ──
if [ ! -t 0 ]; then
	echo "=== LuCI Statistics Dashboard ==="
	do_install
	exit 0
fi

# ── Interactive mode: меню ──
installed=0
[ -f /www/cgi-bin/luci-statistics-dashboard ] && installed=1

while true; do
	clear
	printf "${CYAN}${BOLD}"
	echo "╔══════════════════════════════════════════╗"
	echo "║     LuCI Statistics Dashboard           ║"
	echo "║     CPU · RAM · Network graphs          ║"
	echo "╚══════════════════════════════════════════╝"
	printf "${NC}\n"

	if [ "$installed" = "1" ]; then
		printf "  Статус: ${GREEN}Установлен${NC}\n\n"
	else
		printf "  Статус: ${RED}Не установлен${NC}\n\n"
	fi

	printf "${BOLD}  Выберите:${NC}\n\n"
	printf "  ${GREEN}1)${NC} Установить\n"
	printf "  ${RED}2)${NC} Удалить\n"
	printf "  ${YELLOW}3)${NC} Обновить\n"
	printf "  ${BLUE}4)${NC} Статус\n"
	printf "  ${CYAN}5)${NC} Выход\n\n"
	printf "  >>> "
	read -r choice

	case "$choice" in
		1) do_install ;;
		2)
			if [ "$installed" = "0" ]; then
				printf "\n  ${YELLOW}Уже не установлен.${NC}\n"
			else
				printf "  ${RED}Удалить? (y/N):${NC} "
				read -r c
				case "$c" in
					[yY]|[yY][eE][sS]) do_uninstall; installed=0 ;;
					*) printf "  Отмена.\n" ;;
				esac
			fi
			;;
		3) do_update; installed=1 ;;
		4) do_status ;;
		5) printf "\n  ${GREEN}Пока!${NC}\n"; exit 0 ;;
		*) printf "\n  ${RED}1-5${NC}\n" ;;
	esac

	echo ""
	printf "  Enter..."
	read -r _
done
