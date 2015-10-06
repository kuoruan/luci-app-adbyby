#
# Copyright (C) 2010-2011 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-adbyby
PKG_VERSION:=1.0
PKG_RELEASE:=1.0

include $(INCLUDE_DIR)/package.mk

define Package/luci-app-adbyby
  SECTION:=LuCI
  CATEGORY:=LuCI
  SUBMENU:=3. Applications
  TITLE:=Luci support for adbyby.
  DEPENDS:=+luci +libstdcpp +wget +kmod-nls-utf8
  PKGARCH:=all
endef

define Package/luci-app-adbyby/description
	Luci support for adbyby,only chinese.
endef

define Package/luci-app-adbyby/postinst
#!/bin/sh
[ -n "" ] || {
	( . /etc/uci-defaults/luci-adbyby) && rm -f /etc/uci-defaults/luci-adbyby
	chmod 755 /etc/init.d/adbyby >/dev/null 2>&1
	/etc/init.d/adbyby enable >/dev/null 2>&1
	exit 0
}
endef

define Build/Compile
endef

define Package/luci-app-adbyby/install
	$(CP) ./files/* $(1)
endef

$(eval $(call BuildPackage,luci-app-adbyby))
