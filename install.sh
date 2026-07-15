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

installed=0
[ -f /www/cgi-bin/luci-statistics-dashboard ] && installed=1

banner() {
	clear
	printf "${CYAN}${BOLD}"
	echo "╔══════════════════════════════════════════╗"
	echo "║     LuCI Statistics Dashboard           ║"
	echo "║     CPU · RAM · Network graphs          ║"
	echo "╚══════════════════════════════════════════╝"
	printf "${NC}"
	echo ""
	if [ "$installed" = "1" ]; then
		printf "  Статус: ${GREEN}Установлен${NC}\n\n"
	else
		printf "  Статус: ${RED}Не установлен${NC}\n\n"
	fi
}

menu() {
	printf "${BOLD}  Выберите действие:${NC}\n\n"
	printf "  ${GREEN}1)${NC} Установить\n"
	printf "  ${RED}2)${NC} Удалить\n"
	printf "  ${YELLOW}3)${NC} Обновить\n"
	printf "  ${BLUE}4)${NC} Проверить статус\n"
	printf "  ${CYAN}5)${NC} Выход\n"
	echo ""
	printf "  >>> "
}

do_install() {
	echo ""
	printf "  ${BLUE}[1/5]${NC} Скачивание...\n"
	rm -rf "$TMPDIR"
	mkdir -p "$TMPDIR"
	wget -q -O - "$ARCHIVE" | tar xz -C "$TMPDIR"
	SRC=$(find "$TMPDIR" -maxdepth 1 -type d | tail -1)

	printf "  ${BLUE}[2/5]${NC} Установка шаблона...\n"
	mkdir -p /usr/share/luci/template/statistics-dashboard
	cp "$SRC/ucode/template/statistics-dashboard/dashboard.ut" \
	   /usr/share/luci/template/statistics-dashboard/

	printf "  ${BLUE}[3/5]${NC} Установка меню...\n"
	mkdir -p /usr/share/luci/menu.d
	cp "$SRC/root/usr/share/luci/menu.d/luci-app-statistics-dashboard.json" \
	   /usr/share/luci/menu.d/

	printf "  ${BLUE}[4/5]${NC} Установка CGI API...\n"
	mkdir -p /www/cgi-bin
	cp "$SRC/root/www/cgi-bin/luci-statistics-dashboard" /www/cgi-bin/
	chmod +x /www/cgi-bin/luci-statistics-dashboard

	printf "  ${BLUE}[5/5]${NC} Перезапуск uhttpd...\n"
	/etc/init.d/uhttpd restart

	rm -rf "$TMPDIR"

	echo ""
	printf "  ${GREEN}Готово!${NC}\n"
	printf "  Открой LuCI: Status → Statistics → Dashboard\n"
}

do_uninstall() {
	echo ""
	printf "  ${BLUE}[1/3]${NC} Удаление файлов...\n"
	rm -f /www/cgi-bin/luci-statistics-dashboard
	rm -f /usr/share/luci/menu.d/luci-app-statistics-dashboard.json
	rm -rf /usr/share/luci/template/statistics-dashboard

	printf "  ${BLUE}[2/3]${NC} Перезапуск uhttpd...\n"
	/etc/init.d/uhttpd restart

	printf "  ${BLUE}[3/3]${NC} Готово!\n\n"
	printf "  ${GREEN}Пакет удалён.${NC} Обнови страницу (Ctrl+Shift+R)\n"
}

do_update() {
	echo ""
	printf "  ${YELLOW}Удаление старой версии...${NC}\n"
	rm -f /www/cgi-bin/luci-statistics-dashboard
	rm -f /usr/share/luci/menu.d/luci-app-statistics-dashboard.json
	rm -rf /usr/share/luci/template/statistics-dashboard

	printf "  ${BLUE}[1/5]${NC} Скачивание новой версии...\n"
	rm -rf "$TMPDIR"
	mkdir -p "$TMPDIR"
	wget -q -O - "$ARCHIVE" | tar xz -C "$TMPDIR"
	SRC=$(find "$TMPDIR" -maxdepth 1 -type d | tail -1)

	printf "  ${BLUE}[2/5]${NC} Установка шаблона...\n"
	mkdir -p /usr/share/luci/template/statistics-dashboard
	cp "$SRC/ucode/template/statistics-dashboard/dashboard.ut" \
	   /usr/share/luci/template/statistics-dashboard/

	printf "  ${BLUE}[3/5]${NC} Установка меню...\n"
	mkdir -p /usr/share/luci/menu.d
	cp "$SRC/root/usr/share/luci/menu.d/luci-app-statistics-dashboard.json" \
	   /usr/share/luci/menu.d/

	printf "  ${BLUE}[4/5]${NC} Установка CGI API...\n"
	mkdir -p /www/cgi-bin
	cp "$SRC/root/www/cgi-bin/luci-statistics-dashboard" /www/cgi-bin/
	chmod +x /www/cgi-bin/luci-statistics-dashboard

	printf "  ${BLUE}[5/5]${NC} Перезапуск uhttpd...\n"
	/etc/init.d/uhttpd restart

	rm -rf "$TMPDIR"

	echo ""
	printf "  ${GREEN}Обновлено!${NC}\n"
	printf "  Открой LuCI: Status → Statistics → Dashboard\n"
}

do_status() {
	echo ""
	if [ "$installed" = "1" ]; then
		printf "  ${GREEN}Пакет установлен${NC}\n"
		echo ""
		echo "  Файлы:"
		echo "    /www/cgi-bin/luci-statistics-dashboard"
		echo "    /usr/share/luci/menu.d/luci-app-statistics-dashboard.json"
		echo "    /usr/share/luci/template/statistics-dashboard/dashboard.ut"
	else
		printf "  ${RED}Пакет не установлен${NC}\n"
	fi
}

wait_key() {
	echo ""
	printf "  Нажми Enter чтобы продолжить..."
	read -r _
}

[ "$(id -u)" = "0" ] || { printf "  ${RED}Запусти от root!${NC}\n"; exit 1; }

if [ ! -t 0 ]; then
	printf "  ${YELLOW}Интерактивный режим не доступен (pipe).${NC}\n"
	printf "  Скопируй скрипт и запусти локально:\n\n"
	printf "    wget https://raw.githubusercontent.com/ahu1e/stsatpage/main/install.sh\n"
	printf "    sh install.sh\n\n"
	exit 1
fi

while true; do
	banner
	menu
	read -r choice
	case "$choice" in
		1)
			do_install
			wait_key
			;;
		2)
			if [ "$installed" = "0" ]; then
				echo ""
				printf "  ${YELLOW}Пакет уже не установлен.${NC}\n"
				wait_key
			else
				banner
				printf "  ${RED}Точно удалить? (y/N):${NC} "
				read -r confirm
				case "$confirm" in
					[yY]|[yY][eE][sS])
						do_uninstall
						installed=0
						wait_key
						;;
					*)
						echo ""
						printf "  Отмена.\n"
						wait_key
						;;
				esac
			fi
			;;
		3)
			do_update
			installed=1
			wait_key
			;;
		4)
			do_status
			wait_key
			;;
		5)
			echo ""
			printf "  ${GREEN}Пока!${NC}\n"
			exit 0
			;;
		*)
			echo ""
			printf "  ${RED}Неверный выбор. Введи 1-5.${NC}\n"
			wait_key
			;;
	esac
done
