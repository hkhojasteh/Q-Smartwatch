-- setup I2c and connect display
function init_i2c_display()
    -- SDA and SCL can be assigned freely to available GPIOs
    local sda = 5 -- GPIO14
    local scl = 6 -- GPIO12
    local sla = 0x3c
    i2c.setup(0, sda, scl, i2c.SLOW)
    disp = u8g.ssd1306_128x64_i2c(sla)
end

function prepare()
    disp:setFont(u8g.font_6x10)
    disp:setFontRefHeightExtendedText()
    disp:setDefaultForegroundColor()
    disp:setFontPosTop()
end

function read_clock()
    return rtctime.epoch2cal(rtctime.get())
    -- year, mon, day, hour, min, sec
end

function draw_loop()
    -- Draws one page and schedules the next page, if there is one
    local function draw_pages()
		prepare()
        tm = read_clock()
        if disp:nextPage() then
            print(tm["sec"])
			disp:drawStr(0, 0, tm["year"])
            node.task.post(draw_pages)
        else
            node.task.post(graphics_test)
        end
    end
    -- Restart the draw loop and start drawing pages
    disp:firstPage()
    node.task.post(draw_pages)
end

function graphics_test()
    -- retrigger draw_loop
    node.task.post(draw_loop)
end

init_i2c_display()
print("--- Starting Clock Test ---")
node.task.post(draw_loop)
