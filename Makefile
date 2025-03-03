# File: luci-app-webrestrict/Makefile
include $(TOPDIR)/rules.mk

LUCI_TITLE:=Real-time Web Access Restriction
LUCI_DEPENDS:=+iptables +kmod-ipt-core +kmod-ipt-conntrack +ebtables +luci-compat
LUCI_PKGARCH:=all

PKG_NAME:=luci-app-webrestrict

include $(TOPDIR)/feeds/luci/luci.mk

define Package/$(PKG_NAME)/install
    $(INSTALL_DIR) $(1)/usr/lib/lua/luci/{controller,model/cbi}
    $(INSTALL_DATA) ./luasrc/controller/webrestrict.lua $(1)/usr/lib/lua/luci/controller/
    $(INSTALL_DATA) ./luasrc/model/cbi/webrestrict.lua $(1)/usr/lib/lua/luci/model/cbi/
    
    $(INSTALL_DIR) $(1)/etc/{init.d,config}
    $(INSTALL_BIN) ./root/etc/init.d/webrestrict $(1)/etc/init.d/
    $(INSTALL_DATA) ./root/etc/config/webrestrict $(1)/etc/config/
    
    $(INSTALL_DIR) $(1)/usr/sbin
    $(INSTALL_BIN) ./root/usr/sbin/apply_rules $(1)/usr/sbin/
endef

# 国际化支持
PO_CONFIG:=../../build/i18n-config
PO_LANGUAGES:=zh_Hans

$(eval $(call BuildPackage,$(PKG_NAME)))
