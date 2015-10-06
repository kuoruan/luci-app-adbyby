module("luci.controller.adbyby", package.seeall)
function index()
	if not nixio.fs.access("/etc/config/adbyby") then
		return
	end
	local page
	page = entry({"admin", "services", "adbyby"}, cbi("adbyby"), _("广告屏蔽大师"), 56)
	page.dependent = true
end
