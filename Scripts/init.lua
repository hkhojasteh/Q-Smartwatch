uart.on("data", "\r",
  function(data)
    print("?:", data)
    node.input(data)
    tm = rtctime.epoch2cal(rtctime.get())
    print(string.format("%04d/%02d/%02d %02d:%02d:%02d", tm["year"], tm["mon"], tm["day"], tm["hour"], tm["min"], tm["sec"]))
    if tostring(data) == "quit" then
        print("Goodbye ...")
        uart.on("data") -- unregister callback function
    end
end, 1)