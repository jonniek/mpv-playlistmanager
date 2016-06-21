local mp=require 'mp'
local os=require 'os'
local settings = {
    filepath = "X:\\code\\mpv\\",    --Change this to the path where you want to save playlists, notice trailing \
    osd_duration_seconds = 5
}

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
    mp.osd_message(mp.get_property_osd("playlist"), settings.osd_duration)
end

--Removes the file below current file from playlist
--this makes it easy to navigate with moveup and movedown through playlist and delete files
function removenextfile()
    mp.commandv("playlist-remove", pos+1)
    plen = tonumber(mp.get_property('playlist-count'))
    mp.osd_message(mp.get_property_osd("playlist"), settings.osd_duration)
end

--Moves a file up in playlist order
function moveup()
    if pos-1~=-1 then
        mp.commandv("playlist-move", pos,pos-1)
    else
        mp.commandv("playlist-move", pos,plen)
    end
    mp.osd_message(mp.get_property_osd("playlist"), settings.osd_duration)
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
    mp.osd_message(mp.get_property_osd("playlist"), settings.osd_duration)
    pos = mp.get_property('playlist-pos')
    plen = tonumber(mp.get_property('playlist-count'))
end

--moves the previous file up, allowing seamless reordering
function moveprevup()
    if pos-2~=-1 then
        mp.commandv("playlist-move", pos-1,pos-2)
    else
        mp.commandv("playlist-move", pos-1,plen)
    end
    mp.osd_message(mp.get_property_osd("playlist"), settings.osd_duration)
    pos = mp.get_property('playlist-pos')
    plen = tonumber(mp.get_property('playlist-count'))
end

--moves the next file down, allowing seamless reordering
function movenextdown()
    if pos+2<plen then
        mp.commandv("playlist-move", pos+1,pos+3)
    else
        mp.commandv("playlist-move", pos+1,0)
    end
    mp.osd_message(mp.get_property_osd("playlist"), settings.osd_duration)
    pos = mp.get_property('playlist-pos')
    plen = tonumber(mp.get_property('playlist-count'))
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
function save_playlist()
    local savename = os.time().."-size_"..plen.."-playlist.m3u"
    local file = io.open(settings.filepath..savename, "w")
    if file==nil then
        mp.msg.info("Error in creating playlist file, check permissions and paths")
    else
        local x=0
        while x < plen do
            local filename = mp.get_property('playlist/'..x..'/filename')
            file:write(filename, "\n")
            x=x+1
        end
        print("Playlist written to: "..settings.filepath..savename)
        file:close()
    end
end

mp.add_key_binding('P', 'loadfiles', playlist)
mp.add_key_binding('p', 'saveplaylist', save_playlist)

mp.add_key_binding('UP', 'moveup', moveup)
mp.add_key_binding('DOWN', 'movedown', movedown)
mp.add_key_binding('CTRL+UP', 'moveprevup', moveprevup)
mp.add_key_binding('CTRL+DOWN', 'movenextdown', movenextdown)
mp.add_key_binding('Shift+UP', 'removecurrentfile', removecurrentfile)
mp.add_key_binding('Shift+DOWN', 'removenextfile', removenextfile)

mp.register_event('file-loaded', on_loaded)
