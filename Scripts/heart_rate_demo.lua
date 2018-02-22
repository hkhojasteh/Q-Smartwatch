function read_heart_rate()
    -- Read heart rate iterative
    local function heart_rate()
        val = adc.read(0)
        print("", val)
        -- Restart the read loop and start read again
        node.task.post(read_heart_rate)
    end
    node.task.post(heart_rate)
end

print("--- Starting Heart Rate Test ---")
node.task.post(read_heart_rate)
