# ~/.profile_inc.proxy: sourced by ~/.profile to enable
# automatic proxy-settings based on the routing-table

set_proxy_unifr() {
	export ftp_proxy="http://proxy.uni-freiburg.de:8080"
	export http_proxy="http://proxy.uni-freiburg.de:8080"
	export https_proxy="http://proxy.uni-freiburg.de:8080"
}

# FEEB090A is hex_ip(10.9.235.254)
if grep -qs FEEB090A /proc/net/route ; then
	echo "Detected 10.9.235.0/24 network, setting proxy."
	set_proxy_unifr
fi
