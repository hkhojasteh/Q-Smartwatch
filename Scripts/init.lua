print("Initializing...")
-- rtctime.dsleep(5000000)
-- uart.setup(0, 115200, 8, uart.PARITY_NONE, uart.STOPBITS_1, 1)
rtctime.set(123456);

pin = 4
gpio.mode(pin, gpio.OUTPUT)
gpio.write(pin, gpio.LOW)
gpio.write(pin, gpio.HIGH)

uart.on("data", "\r",
  function(data)
    print("?:", data)
    node.input(data)
    tm = rtctime.epoch2cal(rtctime.get())
    print(string.format("%04d/%02d/%02d %02d:%02d:%02d", tm["year"], tm["mon"], tm["day"], tm["hour"], tm["min"], tm["sec"]))
    if tostring(data) == "bye" then
        print("Goodbye ...")
        uart.on("data") -- unregister callback function
    end
end, 1)