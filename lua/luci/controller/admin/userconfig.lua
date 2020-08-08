#!/usr/bin/lua

module("luci.controller.admin.userconfig", package.seeall)

function index()
    entry({"admin", "userconfig"}, alias("admin", "userconfig", "serial"), _("UserConfig"), nil).index = true --
    --entry({"admin", "userconfig"}, nil, _("UserConfig"), 30).index = true
    entry({"admin", "userconfig", "serial"}, cbi("admin_userconfig/serial"), _("Serial Config"), 1)
    entry({"admin", "userconfig", "protocol"}, cbi("admin_userconfig/protocol"), _("Protocol Type"), 2) --

end
