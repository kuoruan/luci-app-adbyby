local fs = require "nixio.fs"
local util = require "nixio.util"
m = Map("adbyby","广告屏蔽大师","<strong><font color=\"red\">视频广告、网盟广告统统一扫光。</font></strong>")

s = m:section(TypedSection, "adbyby", "基本设置")
s.anonymous = true

s:tab("basic",  translate("设置"))
s:tab("config", translate("ADbyby配置"))
s:tab("user", translate("自定义规则"))


if luci.sys.call("pidof adbyby > /dev/null") == 0 then
	yx = "广告屏蔽大师正在干活！^_^o~ 努力！"
else
	yx ="广告屏蔽大师罢工了！⊙﹏⊙‖好累！"
end
if luci.sys.call("iptables -t nat -L PREROUTING | grep 8118 >> /dev/null") == 0 then	
	dl = "已开启代理"
else
	dl = "未开启代理"
end
date1 = luci.sys.exec("head -1 /usr/share/adbyby/data/lazy.txt | awk -F' ' '{print $3,$4}'")
date2 = luci.sys.exec("head -1 /usr/share/adbyby/data/video.txt | awk -F' ' '{print $3,$4}'")

s:taboption("basic", Flag, "enabled","启用ADbyby","<br /><strong><font color=\"00FFFF\">状态：</font></strong>"..dl.."，"..yx)
s:taboption("basic", Flag, "usesh","开启监视脚本","每5分钟检测一次adbyby是否正常运行")
up = s:taboption("basic", Button, "update","一键更新规则","<br />更新ADbyby的广告过滤规则<br /><strong><font color=\"red\">当前规则日期：</font></strong><br />Lazy : "..date1.."<br />Video : "..date2)
up.inputstyle = "apply"
up.write = function(call)
	luci.sys.call("sh /usr/share/adbyby/sh/update.sh")
end
dw = s:taboption("basic", Button, "dw","关闭透明代理","<br />暂时关闭ADbyby")
dw.inputstyle = "reset"
dw.write = function(closeadbyby)
	luci.sys.call("iptables -t nat -D PREROUTING -p tcp --dport 80 -j REDIRECT --to-ports 8118")
end
kq = s:taboption("basic", Button, "kq","开启透明代理","<br />关闭后当然还要开启啦！")
kq.inputstyle = "apply"
kq.write = function(openadbyby)
	luci.sys.call("iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-ports 8118")
end
s:taboption("basic", DummyValue,"opennewwindow" ,translate("<br /><p align=\"justify\"><script type=\"text/javascript\"></script><input type=\"button\" class=\"cbi-button cbi-button-apply\" value=\"ADbyby官网\" onclick=\"window.open('http://www.adbyby.com/')\" /></p>"),"<strong>www.adbyby.com</strong>")

adbyby_config = s:taboption("config", Value, "_adbyby_config", 
	translate("ADbyby配置"), 
	translate("一般情况保持默认即可"))
adbyby_config.template = "cbi/tvalue"
adbyby_config.rows = 20
adbyby_config.wrap = "off"

function adbyby_config.cfgvalue(self, section)
	return fs.readfile("/usr/share/adbyby/adhook.ini") or ""
end
function adbyby_config.write(self, section, value1)
	if value1 then
		value1 = value1:gsub("\r\n?", "\n")
		fs.writefile("/tmp/adhook.ini", value1)
		if (luci.sys.call("cmp -s /tmp/adhook.ini /usr/share/adbyby/adhook.ini") == 1) then
			fs.writefile("/usr/share/adbyby/adhook.ini", value1)
		end
		fs.remove("/tmp/adhook.ini")
	end
end

editconf_user = s:taboption("user", Value, "_editconf_user", 
	translate("添加自定义规则"), 
	translate("添加你自己的过滤规则"))
editconf_user.template = "cbi/tvalue"
editconf_user.rows = 20
editconf_user.wrap = "off"

function editconf_user.cfgvalue(self, section)
	return fs.readfile("/usr/share/adbyby/cache/user.txt") or ""
end
function editconf_user.write(self, section, value2)
	if value2 then
		value2 = value2:gsub("\r\n?", "\n")
		fs.writefile("/tmp/user.txt", value2)
		if (luci.sys.call("cmp -s /tmp/user.txt /usr/share/adbyby/cache/user.txt") == 1) then
			fs.writefile("/usr/share/adbyby/cache/user.txt", value2)
		end
		fs.remove("/tmp/user.txt")
	end
end

s = m:section(TypedSection, "extrule", translate("第三方规则"))
s.anonymous = true
s.addremove = true
s.template = "cbi/tblsection"

s:option(Value, "address", translate("规则地址"))

return m