#!/bin/sh

# 初始化ipset
ipset -exist create webrestrict hash:mac
ipset flush webrestrict

# 读取配置
enabled=$(uci -q get webrestrict.basic.enabled)
mode=$(uci -q get webrestrict.basic.mode)

# 收集MAC地址
uci -q get webrestrict.@client[] | while read section
do
    mac=$(uci -q get webrestrict.$section.mac)
    [ -n "$mac" ] && ipset add webrestrict $mac
done

# 应用防火墙规则
iptables -D FORWARD -m set --match-set webrestrict src 2>/dev/null
iptables -D FORWARD -m set --match-set webrestrict src 2>/dev/null

if [ "$enabled" = "1" ]; then
    case "$mode" in
        blacklist)
            iptables -I FORWARD -m set --match-set webrestrict src -j DROP
            ;;
        whitelist)
            iptables -I FORWARD -m set --match-set webrestrict src -j ACCEPT
            iptables -I FORWARD -m set ! --match-set webrestrict src -j DROP
            ;;
    esac
fi
