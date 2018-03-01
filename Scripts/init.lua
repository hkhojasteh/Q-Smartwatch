uart.on("data", "\r",
  function(data)
    print("receive from uart:", data)
    node.input(data)
    tm = rtctime.epoch2cal(rtctime.get())
    print(string.format("%04d/%02d/%02d %02d:%02d:%02d", tm["year"], tm["mon"], tm["day"], tm["hour"], tm["min"], tm["sec"]))
    if data=="quit\r" then
      uart.on("data") -- unregister callback function
    end
end, 0)