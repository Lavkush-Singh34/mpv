local volume_file = mp.command_native({"expand-path", "~~/volume-settings.conf"})

function save_volume()
    local volume = mp.get_property("volume")
    local file = io.open(volume_file, "w")
    if file then
        file:write(volume)
        file:close()
    else
        mp.msg.warn("Failed to open volume settings file for writing")
    end
end

function load_volume()
    local file = io.open(volume_file, "r")
    if file then
        local volume = file:read("*n")
        file:close()
        if volume then
            mp.set_property("volume", volume)
        else
            mp.msg.warn("Failed to read volume from file")
        end
    else
        mp.msg.warn("Volume settings file not found")
    end
end

mp.register_event("shutdown", save_volume)
load_volume()

