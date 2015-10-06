print(wifi.sta.getip())
--nil
wifi.setmode(wifi.STATION)
wifi.sta.config("WiFi","PASSWORD")
print(wifi.sta.getip())
--192.168.18.110

-- read temperature with DS18B20
t=require("ds18b20")
t.setup(9)
addrs=t.addrs()

-- a simple http server
srv=net.createServer(net.TCP)
srv:listen(80,function(conn)
    conn:on("receive",function(conn,payload)
        print(payload)
        conn:send(t.read(addrs[1],t.C))
    end)
end)

-- Total DS18B20 numbers, assume it is 2
--print(table.getn(addrs))
-- The second DS18B20
--print(t.read(addrs[2],t.C))
--print(t.read(addrs[2],t.F))
--print(t.read(addrs[2],t.K))
-- Just read
--print(t.read())
-- Just read as centigrade
--print(t.read(nil,t.C))
-- Don't forget to release it after use
t = nil
ds18b20 = nil
package.loaded["ds18b20"]=nil
