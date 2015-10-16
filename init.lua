--------------------------------------------------------------------------------
-- Filename :  init.lua
-- Description : Read DS18B20 sensors on a NodeMCU and save the data to thingspeak
--       AUTHOR:  Paul Biester, https://github.com/isonet
--      VERSION:  1.0
--      CREATED:  2015-10-16
--------------------------------------------------------------------------------

-- Require the library for the sensors
require('ds18b20')


function onMonitor(sensorPins)
    --sendData(readSensor(4))
    for i = 1, table.getn(sensorPins) do
        sendData("field"..i, readSensor(sensorPins[i]))
    end
end

function readSensor(pin)
    ds18b20.setup(pin)
    print("Sensor on pin "..pin.." : "..ds18b20.read())
    return ds18b20.read()
end

function sendData(field, data)
    -- conection to thingspeak.com
    local conn = net.createConnection(net.TCP, 0)
    conn:on("receive", function(conn, payload) print(payload) end)
    -- api.thingspeak.com 144.212.80.11
    conn:connect(80,'144.212.80.11')
    conn:send("GET /update?key=Z6C7L57VREBTS7HM&"..field.."="..data.." HTTP/1.1\r\n")
    conn:send("Host: api.thingspeak.com\r\n")
    conn:send("Accept: */*\r\n")
    conn:send("User-Agent: Mozilla/4.0 (compatible; esp8266 Lua; Windows NT 5.1)\r\n")
    conn:send("\r\n")
    conn:on("sent",function(conn)
                      print("Closing connection")
                      conn:close()
                  end)
end

function wifiSetup(ssid, password)
    wifi.setmode(wifi.STATION)
    wifi.sta.config(ssid,password)
    print(wifi.sta.getip())
end

local temperatureSensors = {}
temperatureSensors[1] = 4
--temperatureSensors[2] = 5

local SSID = ""
local PASSWORD = ""

wifiSetup(SSID, PASSWORD)

-- Every 30 seconds...
tmr.alarm(0, 30000, 1, onMonitor({temperatureSensors}))
