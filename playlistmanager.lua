local mp=require 'mp'
local file =nil
local path = nil

function on_loaded(event)
    mpvpath = mp.get_property('path')
    pos = mp.get_property('playlist-pos')
    plen = tonumber(mp.get_property('playlist-count'))

    path = string.sub(mp.get_property("path"), 1, string.len(mp.get_property("path"))-string.len(mp.get_property("filename")))
    file = mp.get_property("filename")
end

--removes the current file from playlist
function removecurrentfile()
    mp.commandv("playlist-remove", "current")
    plen = tonumber(mp.get_property('playlist-count'))
    mp.commandv("keypress", "F9")
end

--Removes the file below current file from playlist
--this makes it easy to navigate with moveup and movedown through playlist and delete files
function removefile()
    mp.commandv("playlist-remove", pos+1)
    plen = tonumber(mp.get_property('playlist-count'))
    mp.commandv("keypress", "F9")
end

--Moves a file up in playlist order
function moveup()
    print(pos..plen)
    if pos-1~=-1 then
        mp.commandv("playlist-move", pos,pos-1)
    else
        mp.commandv("playlist-move", pos,plen)
    end
    mp.commandv("keypress", "F9")
    pos = mp.get_property('playlist-pos')
    plen = tonumber(mp.get_property('playlist-count'))
    print("File moved up")
end

--Moves a file down in playlist order
function movedown()
    if pos+1<plen then
        mp.commandv("playlist-move", pos,pos+2)
    else
        mp.commandv("playlist-move", pos,0)
    end
    mp.commandv("keypress", "F9")
    pos = mp.get_property('playlist-pos')
    plen = tonumber(mp.get_property('playlist-count'))
    print("File moved down")
end

--moves a file to the end of playlist, and starts playing the next file
function movetoend()
    mp.commandv("loadfile", mpvpath, "append")
    mp.commandv("playlist-remove", "current")
end

--Attempts to add all files following the currently playing one to the playlist
--For exaple, Folder has 12 files, you open the 5th file and run this, the remaining 7 are added behind the 5th file
function playlist()
    local popen = io.popen('dir /b "'..path..'*"') --windows version
    --local popen = io.popen('find '..path..'* -type f -printf "%f\\n"') --linux version, not tested
    if popen then 
        local cur = false
        local c= 0
        for dirx in popen:lines() do
            if cur == true then
                mp.commandv("loadfile", path..dirx, "append")
                mp.msg.info("Appended to playlist: " .. dirx)
                c = c + 1
            end
            if dirx == file then
                cur = true
            end
        end
        popen:close()
        if c > 0 then mp.osd_message("Added total of: "..c.." files to playlist") end
    end
    plen = tonumber(mp.get_property('playlist-count'))
end

mp.add_key_binding('P', 'loadfiles', playlist)

--add> F9 show-text "${playlist}" 5000 <to your input conf to display playlist when navigating
mp.add_key_binding('F4', 'removecurrentfile', removecurrentfile)
mp.add_key_binding('F5', 'removefile', removefile)
mp.add_key_binding('F6', 'moveup', moveup)
mp.add_key_binding('F7', 'movedown', movedown)
mp.add_key_binding('F8', 'movetoend', movetoend)
mp.register_event('file-loaded', on_loaded)
