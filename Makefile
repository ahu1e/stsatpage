include $(TOPDIR)/rules.mk

LUCI_NAME:=luci-app-statistics-dashboard
LUCI_TITLE:=Statistics Dashboard — CPU, RAM, Network graphs
LUCI_DEPENDS:=+luci-base

PKG_LICENSE:=MIT

include ../../luci.mk
