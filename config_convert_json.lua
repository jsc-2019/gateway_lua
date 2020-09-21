#!/usr/bin/env lua
-- 参考网址：https://blog.csdn.net/lzz957748332/article/details/52575369?utm_medium=distribute.pc_relevant.none-task-blog-BlogCommendFromMachineLearnPai2-3.edu_weight&depth_1-utm_source=distribute.pc_relevant.none-task-blog-BlogCommendFromMachineLearnPai2-3.edu_weight
-- print("Testing start..")
require("uci")

-- Get asection type or an option
-- x =uci.cursor()

-- a =x:get("user_config", "", "test_var")
-- if a == nil then
--     print("can't found the config file")
--     return
-- else
--     print(a)
-- end

-- Getthe configuration directory
-- b =x:get_confdir()
-- print(b)

-- Getall sections of a config or all values of a section
-- d = x:get_all("user_config", "serial_config")
-- print("config serial_config")
-- if a == nil then
--     print("can't found the config file")
--     return
-- else
--     print(d)
--     print(d["serial_num"])
--     print(d["sensor_type"])

-- loop a config
-- x:foreach("user_config", "serial_config", function(s) 
--     print("----serial_config")
--     for k,v in pairs(s) do
--         print(k..":"..tostring(v))
--     end
--     print("sensor_manufacturer", s["sensor_manufacturer"])
-- end)

-- function getConfType(conf,type)
--     local curs=uci.cursor()
--     local ifce={}
--     curs:foreach(conf,type,function(s) ifce[s[".index"]]=s end)  --function(s) 后面就是回调函数的函数体,参数s是一个table类型，可以参考lua语法之数据类型
--     return ifce   --这里的ifce是table类型，通过上述赋值，可知ifce嵌套了一张table，即ifce["key"]也仍然是table类型

-- c = getConfType("user_config", "protocol_config")
-- print("-----protocol_config")
-- for k,v in pairs(c) do
--     print("key=", k)
--     for k2,v2 in pairs(a[k]) do  --因为c是table里面嵌套了一个table，所以有两个for循环。
--         print(k2..":"..tostring(v2))
--     end
-- end
local json = require "cjson"
local util = require "cjson.util"
local fs = require "nixio.fs"

function getConfType(conf,type)
    local curs=uci.cursor()
    local ifce={}
    curs:foreach(conf,type,function(s) ifce["key"]=s end)  --function(s) 后面就是回调函数的函数体,参数s是一个table类型，可以参考lua语法之数据类型
    return ifce["key"]   --这里的ifce是table类型，通过上述赋值，可知ifce嵌套了一张table，即ifce["key"]也仍然是table类型
end

a = getConfType("user_config", "serial_config")
print("-----serial_config")
for k,v in pairs(a) do
    print(k..":"..tostring(v))
end

b = getConfType("user_config", "protocol_config")
print("-----protocol_config")
print(util.serialise_value(b))
-- for k,v in pairs(b) do
--     print(k..":"..tostring(v))
-- end


local json_file_path = "/usr/local/gateway/config/gateway_config.json"
-- local json_file_path = "./test.json"

local t = {}
if fs.access(json_file_path) then
    local json_text = util.file_load(json_file_path)
    t = json.decode(json_text)
    print("-----json")
    print(util.serialise_value(t))
else
    print("can't found the config file:", json_file_path)
    return 
end

-- print("uart:", t["user_config"]["uart"][2]["name"])

-- t["user_config"]["uart"][2]["name"] = "uart4"
print("uart:", t["user_config"]["uart"][a["serial_num"]+1]["name"])
local serial_num = {"ttyS0", "ttyS1", "ttyS2"}
local serial_baud = {"2400", "4800", "9600", "38400", "57600", "115200", "230400", "380400", "460800"}
local serial_data = {"5", "6", "7", "8"}
local serial_parity = {"None", "Odd", "Even", "Mark", "Space"}
local serial_stop = {"1", "2"}
local sensor_mode = {"DTU", "GROUP"}
t["user_config"]["uart"][a["serial_num"]+1]["parity"] = serial_parity[a["serial_parity"]+1]
t["user_config"]["uart"][a["serial_num"]+1]["sensor"]["sensor_manufacture"] = a["sensor_manufacturer"]
t["user_config"]["uart"][a["serial_num"]+1]["sensor"]["sensor_number"] = a["sensor_number"]
t["user_config"]["uart"][a["serial_num"]+1]["sensor"]["sensor_type"] = a["sensor_type"]
t["user_config"]["uart"][a["serial_num"]+1]["sensor"]["client_name"] = "BeiSi"
t["user_config"]["uart"][a["serial_num"]+1]["name"] = serial_num[a["serial_num"]+1]
t["user_config"]["uart"][a["serial_num"]+1]["active"] = true
t["user_config"]["uart"][a["serial_num"]+1]["trans_mode"] = sensor_mode[a["sensor_mode"]+1]
t["user_config"]["uart"][a["serial_num"]+1]["databits"] = serial_data[a["serial_data"]+1]
t["user_config"]["uart"][a["serial_num"]+1]["baund"] = serial_baud[a["serial_baud"]+1]
t["user_config"]["uart"][a["serial_num"]+1]["stopbits"] = serial_stop[a["serial_stop"]+1]


t["cloud_config"]["mqtt"]["host"] = b["server_ip"]
t["cloud_config"]["mqtt"]["port"] = b["server_port"]
t["cloud_config"]["mqtt"]["qos"] = b["qos"]
t["cloud_config"]["mqtt"]["publish_topic"] = b["publish_topic"]
t["cloud_config"]["mqtt"]["subscribe_topic"] = b["subscribe_topic"]
-- t["cloud_config"]["mqtt"]["sendPeriod"] = 
-- t["cloud_config"]["mqtt"]["sampleTime"] = 
-- t["cloud_config"]["mqtt"]["filterPath"] = 

-- t["cloud_config"]["tcp"]["host"] = 
-- t["cloud_config"]["tcp"]["port"] = 


local jsonStr = json.encode(t);
print(jsonStr);
file = io.open("./test.json", "w")
io.output(file)
io.write(jsonStr)
io.close(file)