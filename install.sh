#!/bin/sh

set -e

REPO="https://github.com/ahu1e/stsatpage.git"
TMPDIR="/tmp/luci-app-statistics-dashboard"

echo "=== LuCI Statistics Dashboard installer ==="

if [ "$(id -u)" != "0" ]; then
	echo "Run as root: sh install.sh"
	exit 1
fi

echo "[1/5] Cloning repo..."
rm -rf "$TMPDIR"
git clone --depth 1 "$REPO" "$TMPDIR"

echo "[2/5] Installing template..."
mkdir -p /usr/share/luci/template/statistics-dashboard
cp "$TMPDIR/ucode/template/statistics-dashboard/dashboard.ut" \
   /usr/share/luci/template/statistics-dashboard/

echo "[3/5] Installing menu..."
mkdir -p /usr/share/luci/menu.d
cp "$TMPDIR/root/usr/share/luci/menu.d/luci-app-statistics-dashboard.json" \
   /usr/share/luci/menu.d/

echo "[4/5] Installing CGI API..."
mkdir -p /www/cgi-bin
cp "$TMPDIR/root/www/cgi-bin/luci-statistics-dashboard" /www/cgi-bin/
chmod +x /www/cgi-bin/luci-statistics-dashboard

echo "[5/5] Restarting uhttpd..."
/etc/init.d/uhttpd restart

rm -rf "$TMPDIR"

echo ""
echo "Done! Open: http://$(uci get network.lan.ipaddr)/cgi-bin/luci-statistics-dashboard"
