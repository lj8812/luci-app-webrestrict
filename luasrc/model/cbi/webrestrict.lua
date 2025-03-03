-- File: luasrc/model/cbi/webrestrict.lua
local uci = luci.model.uci.cursor()
local sys = require "luci.sys"

m = Map("webrestrict", translate("访问限制"), 
    translate("实时网络访问控制，基于MAC地址进行流量管理"))

function m.on_after_commit(self)
    os.execute("/etc/init.d/webrestrict reload >/dev/null 2>&1")
end

-- 全局设置
s = m:section(TypedSection, "basic", translate("全局设置"))
s.anonymous = true

enable = s:option(Flag, "enabled", translate("启用控制"))
enable.rmempty = false

mode = s:option(ListValue, "mode", translate("控制模式"))
mode:value("blacklist", translate("黑名单模式（禁止列表设备上网）"))
mode:value("whitelist", translate("白名单模式（仅允许列表设备上网）"))

-- 客户端列表
clients = m:section(TypedSection, "client", translate("设备列表"), 
    translate("MAC地址格式：00:11:22:33:44:55"))
clients.template = "cbi/tblsection"
clients.addremove = true
clients.anonymous = true

mac = clients:option(Value, "mac", translate("MAC地址"))
mac.datatype = "macaddr"
mac.rmempty = false

sys.net.mac_hints(function(mac, name)
    mac:value(mac, "%s (%s)" %{mac, name or "未知设备"})
end)

return m
