local utils = require 'mp.utils'
local msg = require 'mp.msg'

-- Function to add files in the directory to the playlist
local function add_files_to_playlist()
    local path = mp.get_property("path")
    if not path then
        return
    end

    local dir, filename = utils.split_path(path)
    if not dir then
        return
    end

    local files = utils.readdir(dir, "files")
    if not files then
        return
    end

    table.sort(files)

    local exts = { 'mkv', 'mp4', 'avi', 'mov', 'webm', 'flv', 'wmv' }
    local playlist = {}
    local found = false

    for i, file in ipairs(files) do
        local ext = file:match("^.+%.(.+)$")
        if ext and ext:match("^%a+$") then
            ext = ext:lower()
            for _, v in pairs(exts) do
                if ext == v then
                    table.insert(playlist, file)
                    if file == filename then
                        found = true
                    end
                    break
                end
            end
        end
    end

    if found then
        local pos = 0
        for i, file in ipairs(playlist) do
            if file == filename then
                pos = i - 1
                break
            end
        end

        for i, file in ipairs(playlist) do
            if i ~= pos + 1 then
                mp.commandv("loadfile", utils.join_path(dir, file), "append")
            end
        end

        mp.commandv("playlist-pos", pos)
    end
end

mp.register_event("start-file", add_files_to_playlist)

