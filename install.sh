#!/bin/sh

set -e

REPO="https://github.com/ahu1e/stsatpage"
ARCHIVE="$REPO/archive/refs/heads/main.tar.gz"
TMPDIR="/tmp/luci-app-statistics-dashboard"

do_install() {
	echo "=== LuCI Statistics Dashboard — установка ==="

	[ "$(id -u)" = "0" ] || { echo "Запусти от root: sh install.sh"; exit 1; }

	echo "[1/5] Скачивание..."
	rm -rf "$TMPDIR"
	mkdir -p "$TMPDIR"
	wget -q -O - "$ARCHIVE" | tar xz -C "$TMPDIR" --strip-components=1

	echo "[2/5] Установка шаблона..."
	mkdir -p /usr/share/luci/template/statistics-dashboard
	cp "$TMPDIR/ucode/template/statistics-dashboard/dashboard.ut" \
	   /usr/share/luci/template/statistics-dashboard/

	echo "[3/5] Установка меню..."
	mkdir -p /usr/share/luci/menu.d
	cp "$TMPDIR/root/usr/share/luci/menu.d/luci-app-statistics-dashboard.json" \
	   /usr/share/luci/menu.d/

	echo "[4/5] Установка CGI API..."
	mkdir -p /www/cgi-bin
	cp "$TMPDIR/root/www/cgi-bin/luci-statistics-dashboard" /www/cgi-bin/
	chmod +x /www/cgi-bin/luci-statistics-dashboard

	echo "[5/5] Перезапуск uhttpd..."
	/etc/init.d/uhttpd restart

	rm -rf "$TMPDIR"

	echo ""
	echo "Готово! Открой: http://$(uci get network.lan.ipaddr)/cgi-bin/luci-statistics-dashboard"
}

do_uninstall() {
	echo "=== LuCI Statistics Dashboard — удаление ==="

	[ "$(id -u)" = "0" ] || { echo "Запусти от root: sh install.sh --uninstall"; exit 1; }

	echo "[1/3] Удаление файлов..."
	rm -f /www/cgi-bin/luci-statistics-dashboard
	rm -f /usr/share/luci/menu.d/luci-app-statistics-dashboard.json
	rm -rf /usr/share/luci/template/statistics-dashboard

	echo "[2/3] Перезапуск uhttpd..."
	/etc/init.d/uhttpd restart

	echo "[3/3] Обнови страницу в браузере (Ctrl+Shift+R)"

	echo ""
	echo "Готово! Пакет удалён."
}

case "${1:-}" in
	--uninstall|-u)
		do_uninstall
		;;
	*)
		do_install
		;;
esac
# Wed Jul 15 22:05:44 MSK 2026
