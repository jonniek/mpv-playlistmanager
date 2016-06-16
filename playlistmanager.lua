local mp=require 'mp'
local os=require 'os'
local file = nil
local path = nil

function on_loaded()
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
    if pos-1~=-1 then
        mp.commandv("playlist-move", pos,pos-1)
    else
        mp.commandv("playlist-move", pos,plen)
    end
    mp.commandv("keypress", "F9")
    pos = mp.get_property('playlist-pos')
    plen = tonumber(mp.get_property('playlist-count'))
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

--saves the current playlist into a m3u file
local filepath = "X:\\code\\mpv\\"      --Change this to the path where you want to save playlists, notice trailing \
function save_playlist()
    local savename = os.time().."-size_"..plen.."-playlist.m3u"
    local file = io.open(filepath..savename, "w")
    local x=0
    while x < plen do
        local filename = mp.get_property('playlist/'..x..'/filename')
        file:write(filename, "\n")
        x=x+1
    end
    print("Playlist written to: "..filepath..savename)
    file:close()
end

mp.add_key_binding('P', 'loadfiles', playlist)
mp.add_key_binding('p', 'saveplaylist', save_playlist)

--add> F9 show-text "${playlist}" 5000 <to your input conf to display playlist when navigating
mp.add_key_binding('F4', 'removecurrentfile', removecurrentfile)
mp.add_key_binding('F5', 'removefile', removefile)
mp.add_key_binding('F6', 'moveup', moveup)
mp.add_key_binding('F7', 'movedown', movedown)
mp.add_key_binding('F8', 'movetoend', movetoend)

mp.register_event('file-loaded', on_loaded)
