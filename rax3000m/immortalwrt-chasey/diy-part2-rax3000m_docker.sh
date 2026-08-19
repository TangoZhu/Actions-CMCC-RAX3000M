#!/bin/bash
# Description: OpenWrt DIY script part 2 for Docker build (After Update feeds)

# 1. 添加备份路径
SYSUPGRADE_CONF="package/base-files/files/etc/sysupgrade.conf"
if [ -f "$SYSUPGRADE_CONF" ]; then
    echo '/etc/nikki/run/geoip.metadb' >> "$SYSUPGRADE_CONF"
fi

# 2. 修改默认 IP 与 NTP 服务器
CFG_GEN="package/base-files/files/bin/config_generate"
if [ -f "$CFG_GEN" ]; then
    sed -i 's/192.168.1.1/192.168.2.1/g' "$CFG_GEN"
    sed -i "s/0.openwrt.pool.ntp.org/ntp.aliyun.com/g" "$CFG_GEN"
    sed -i "s/1.openwrt.pool.ntp.org/cn.ntp.org.cn/g" "$CFG_GEN"
    sed -i "s/2.openwrt.pool.ntp.org/cn.pool.ntp.org/g" "$CFG_GEN"
fi

# 3. 修正最大连接数
SYSCTL_CONF="package/base-files/files/etc/sysctl.conf"
if [ -f "$SYSCTL_CONF" ]; then
    sed -i '/customized in this file/a net.netfilter.nf_conntrack_max=65535' "$SYSCTL_CONF"
fi

# 4. 替换/拉取第三方应用 packages
rm -rf feeds/luci/applications/luci-app-openclash
git clone https://github.com/vernesong/OpenClash.git --depth=1 feeds/luci/applications/luci-app-openclash

rm -rf feeds/luci/applications/luci-app-openvpn-server
git clone https://github.com/shawnpxtl/luci-app-openvpn-server.git --depth=1 feeds/luci/applications/luci-app-openvpn-server