-- setup I2c and connect display
function init_i2c_display()
    -- SDA and SCL can be assigned freely to available GPIOs
    local sda = 5 -- GPIO14
    local scl = 6 -- GPIO12
    local sla = 0x3c
    i2c.setup(0, sda, scl, i2c.SLOW)
    disp = u8g.ssd1306_128x64_i2c(sla)
end

local step = 0
local lastData = {}
function read_heart_rate()
    -- Read heart rate iterative
    rawval = adc.read(0);
    val = (rawval * 64) / 900
    --print(rawval)
    lastData[step] = val
end

function draw_loop()
    -- Draws one page and schedules the next page, if there is one
    local function draw_pages()
        read_heart_rate()
        if disp:nextPage() then
            for i=1, 128 do
                if lastData[i] ~= 0 then
                    disp:drawVLine(i, 64 - lastData[i], lastData[i])
                end
            end
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
    -- Clear buffer for next drawing
    clear_data()
    step = (step + 1) % 128
    -- retrigger draw_loop
    node.task.post(draw_loop)
end

function clear_data()
    if step == 0 then
        for i=1, 128 do
            lastData[i] = 0
        end
    end
end

init_i2c_display()
print("--- Starting Heart Rate Test ---")
clear_data()
node.task.post(draw_loop)