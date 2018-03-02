-- setup I2c and connect display
function init_i2c_display()
    -- SDA and SCL can be assigned freely to available GPIOs
    local sda = 5 -- GPIO14
    local scl = 6 -- GPIO12
    local sla = 0x3c
    i2c.setup(0, sda, scl, i2c.SLOW)
    disp = u8g.ssd1306_128x64_i2c(sla)
end

function read_clock()
    return rtctime.epoch2cal(rtctime.get())
    -- year, mon, day, hour, min, sec
end

function draw_loop()
    -- Draws one page and schedules the next page, if there is one
    local function draw_pages()
        tm = read_clock()
        if disp:nextPage() then
            disp:setFont(u8g.font_04b_03bn)
            disp:drawStr90(15, 10, string.format("%04d/%02d/%02d", tm["year"], tm["mon"], tm["day"]))
            disp:setFont(u8g.font_freedoomr25n)
            disp:drawStr90(25, 15, string.format("%02d", tm["sec"]))
            disp:drawStr90(55, 15, string.format("%02d", tm["min"]))
            disp:drawStr90(85, 15, string.format("%02d", tm["hour"]))
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
