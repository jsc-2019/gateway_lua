#!/usr/bin/env lua

local sys   = require "luci.sys"
local zones = require "luci.sys.zoneinfo"
local fs    = require "nixio.fs"
local conf  = require "luci.config"

local m, s, o

m = Map("user_config", translate("Protocol Config"), translate("Here you can configure the basic aspects of your device like its hostname or the timezone."))
m:chain("luci")

s = m:section(TypedSection, "protocol_config", translate("protocol config"))
s.anonymous = true     --
s.addremove = false

--mqtt config
s:tab("mqtt", translate("Config MQTT"))  

o = s:taboption("mqtt", Value, "server_ip", translate("Server IP:"))
o.datatype = "ip4addr"


o = s:taboption("mqtt", Value, "server_port", translate("Server PORT:"))
o.datatype = "port"

-- function o.write(self, section, value)
--     Value.write(self, section, value)
--     sys.port(value)
-- end


o = s:taboption("mqtt", Value, "device_id", translate("Device ID:"))
o.datatype = "string"

o = s:taboption("mqtt", ListValue, "qos", translate("mqtt qos:"))
o.default = 0
o.datatype = "uinteger"
o:value(0, translate("0"))
o:value(1, translate("1"))
o:value(2, translate("2"))

o = s:taboption("mqtt", DynamicList, "publish_topic", translate("Publish Topic:"))
o.datatype = "string"


o = s:taboption("mqtt", DynamicList, "subscribe_topic", translate("Subscribe Topic:"))
o.datatype = "string"


o = s:taboption("mqtt", Value, "server_user", translate("Server User:"))
o.datatype = "string"


o = s:taboption("mqtt", Value, "server_password", translate("Server Password:"))
o.datatype = "string"
o.password = true

--http config
s:tab("http", translate("Config HTTP"))  

o = s:taboption("http", Value, "http_server_ip", translate("Server IP:"))
o.datatype = "ip4addr"

-- function o.write(self, section, value)
--     Value.write(self, section, value)
--     sys.ip4addr(value)
-- end


o = s:taboption("http", Value, "http_server_port", translate("Server PORT:"))
o.datatype = "port"

-- function o.write(self, section, value)
--     Value.write(self, section, value)
--     sys.port(value)
-- end


--tcp config
s:tab("tcp", translate("Config TCP"))  

o = s:taboption("tcp", Value, "tcp_server_ip", translate("Server IP:"))
o.datatype = "ip4addr"

-- function o.write(self, section, value)
--     Value.write(self, section, value)
--     sys.ip4addr(value)
-- end


o = s:taboption("tcp", Value, "tcp_server_port", translate("Server PORT:"))
o.datatype = "port"

-- function o.write(self, section, value)
--     Value.write(self, section, value)
--     sys.port(value)
-- end


local apply = luci.http.formvalue("cbi.apply")
if apply then
    io.popen("/etc/init.d/user_config restart")
end

return m    --必须要返回map，不然页面就显示不了section