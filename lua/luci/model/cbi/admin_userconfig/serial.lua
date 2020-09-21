#!/usr/bin/env lua

local sys   = require "luci.sys"
-- local zones = require "luci.sys.zoneinfo"
local fs    = require "nixio.fs"

local m, s, o

m = Map("user_config", translate("Serial Config"), translate("Here you can configure the basic aspects of your device like its hostname or the timezone."))
m:chain("luci")

s = m:section(TypedSection, "serial_config", translate("serial config"))
--[[
接下来需要创建与配置文件中对应的Section，Section分为两种，NamedSection和TypedSection，前者根据配置文件中的Section名，
而后者根据配置文件中的Section类型，这里我们使用后者。我们设定不显示Section的名称（“s.anonymous = true”），以及不允许
增加或删除Section(“s.addremove =false”)。serial_config即为 配置文件其中的一个配置。
]]
s.anonymous = true     --
s.addremove = false

--serial config
s:tab("serial", translate("Config Serial"))  

o = s:taboption("serial", ListValue, "serial_num", translate("Serial NUM:"))
o.default = 1
o.datatype = "uinteger"
o:value(0, translate("ttyS0"))
o:value(1, translate("ttyS1"))
o:value(2, translate("ttyS2"))

o = s:taboption("serial", ListValue, "serial_baud", translate("Serizl BAUD:"))
o.default = 2
o.datatype = "uinteger"
o:value(0, translate("2400"))
o:value(1, translate("4800"))
o:value(2, translate("9600"))
o:value(3, translate("38400"))
o:value(4, translate("57600"))
o:value(5, translate("115200"))
o:value(6, translate("230400"))
o:value(7, translate("380400"))
o:value(8, translate("460800"))

o = s:taboption("serial", ListValue, "serial_data", translate("DATA BIT:"))
o.default = 3
o.datatype = "uinteger"
o:value(0, translate("5"))
o:value(1, translate("6"))
o:value(2, translate("7"))
o:value(3, translate("8"))

o = s:taboption("serial", ListValue, "serial_parity", translate("Serial Parity:"))
o.default = 0
o.datatype = "uinteger"
o:value(0, translate("None"))
o:value(1, translate("Odd"))
o:value(2, translate("Even"))
o:value(3, translate("Mark"))
o:value(4, translate("Space"))

o = s:taboption("serial", ListValue, "serial_stop", translate("Serial STOP:"))
o.default = 0
o.datatype = "uinteger"
o:value(0, translate("1"))
o:value(1, translate("2"))

o = s:taboption("serial", Value, "sensor_manufacturer", translate("Sensor manufacturer:"))
o.datatype = "string"

-- function o.write(self, section, value)
-- 	Value.write(self, section, value)
-- 	sys.string(value)
-- end


o = s:taboption("serial", Value, "sensor_type", translate("Sensor type:"))
o.datatype = "string"

-- function o.write(self, section, value)
-- 	Value.write(self, section, value)
-- 	sys.string(value)
-- end


o = s:taboption("serial", Value, "sensor_number", translate("Sensor number:"))
o.datatype = "string"

-- function o.write(self, section, value)
-- 	Value.write(self, section, value)
-- 	sys.string(value)
-- end
-- o = s:taboption("serial", ListValue, "sensor_number", translate("Sensor number:"))
-- o.default = 0
-- o.datatype = "uinteger"
-- o:value(0, translate("beisi001"))
-- o:value(1, translate("1.5"))
-- o:value(2, translate("2"))

o = s:taboption("serial", ListValue, "sensor_mode", translate("Sensor Mode:"))
o.default = 0
o.datatype = "uinteger"
o:value(0, translate("DTU"))
o:value(1, translate("GROUP"))

-- 通过如下的代码判断是否点击了“应用”按钮： 如果点击了，就执行if里面的语句
local apply = luci.http.formvalue("cbi.apply")
if apply then
    io.popen("lua /usr/local/gateway/config_convert_json.lua")
end

return m