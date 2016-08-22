local settings = {
    filepath = "X:\\code\\mpv\\",                     --Change this to the path where you want to save playlists, notice trailing \ or /
    osd_duration_seconds = 5,                         --osd duration displayed when navigating
    filetypes = {'*mkv','*mp4','*jpg','*gif','*png'}, --filetypes to search, if true all filetypes are opened, else array like {'*mp4','*mkv'}
    linux_over_windows = false,                       --linux(true)/windows(false) toggle
    sortplaylist_on_start = false,                    --sort on mpv start
                                    
    remove_old = true,   --removes old files on long playlists, keeping it somewhatreadable/navigatable
    --first value is how long playlist has to be to start removing old entries
    --second value is at what playlist position they should be removed at
    old_buffer = {14,8}, 
    old_loop = false     --instead of removing, move them to end of playlist, creating a infinitely looping playlist                      
}


function on_loaded()
    if settings.remove_old then
        if tonumber(mp.get_property('playlist-count')) > settings.old_buffer[1] and 
           tonumber(mp.get_property('playlist-pos'))> settings.old_buffer[2] then
                if settings.old_loop then
                    local oldfile = mp.get_property('playlist/0/filename')
                    mp.commandv("playlist-remove", 0) 
                    mp.commandv("loadfile", oldfile, "append")
                else
                    mp.commandv("playlist-remove", 0)
                end
        end
    end

    mpvpath = mp.get_property('path')
    pos = mp.get_property('playlist-pos')
    plen = tonumber(mp.get_property('playlist-count'))
    path = string.sub(mp.get_property("path"), 1, string.len(mp.get_property("path"))-string.len(mp.get_property("filename")))
    file = mp.get_property("filename")
    
    search =' '
    if settings.filetypes == true then
        search = string.gsub(path, "%s+", "\\ ")..'*'
    else
        for w in pairs(settings.filetypes) do
            if settings.linux_over_windows then
                search = search..string.gsub(path, "%s+", "\\ ")..settings.filetypes[w]..' '
            else
                search = search..'"'..path..settings.filetypes[w]..'" '
            end
        end
    end
end

function showplaylist()
    mp.osd_message(mp.get_property_osd("playlist"), settings.playlist_osd_dur)
end

--removes the current file from playlist
function removecurrentfile()
    mark=true
    mp.commandv("playlist-remove", "current")
    plen = tonumber(mp.get_property('playlist-count'))
    mp.add_timeout(0.15, showplaylist)
end

--Removes the file below current file from playlist
--this makes it easy to navigate with moveup and movedown through playlist and delete files
function removenextfile()
    mp.commandv("playlist-remove", pos+1)
    plen = tonumber(mp.get_property('playlist-count'))
    showplaylist()
end

--Moves current file up in playlist order
function moveup()
    if pos-1~=-1 then
        mp.commandv("playlist-move", pos,pos-1)
    else
        mp.commandv("playlist-move", pos,plen)
    end
    showplaylist()
    pos = mp.get_property('playlist-pos')
end

--Moves current file down in playlist order
function movedown()
    if pos+1<plen then
        mp.commandv("playlist-move", pos,pos+2)
    else
        mp.commandv("playlist-move", pos,0)
    end
    showplaylist()
    pos = mp.get_property('playlist-pos')
end
--moves the previous file up, allowing seamless reordering
function moveprevup()
    if pos-2~=-1 then
        mp.commandv("playlist-move", pos-1,pos-2)
    else
        mp.commandv("playlist-move", pos-1,plen)
    end
    showplaylist()
    pos = mp.get_property('playlist-pos')
end

--moves the next file down, allowing seamless reordering
function movenextdown()
    if pos+2<plen then
        mp.commandv("playlist-move", pos+1,pos+3)
    else
        mp.commandv("playlist-move", pos+1,0)
    end
    showplaylist()
    pos = mp.get_property('playlist-pos')
end

--Attempts to add all files following the currently playing one to the playlist
--For exaple, Folder has 12 files, you open the 5th file and run this, the remaining 7 are added behind the 5th file
function playlist()
    local popen=nil
    if settings.linux_over_windows then
        popen = io.popen('find '..search..' -type f -printf "%f\\n" 2>/dev/null') --linux version, not tested, if it doesn't work fix it to print filenames only 1 per row
        --print('find '..search..' -type f -printf "%f\\n"')
    else
        popen = io.popen('dir /b '..search) --windows version
    end
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
        if c > 0 then mp.osd_message("Added a total of "..c.." files to playlist") end
    else
        print("error: could not scan for files")
    end
    plen = tonumber(mp.get_property('playlist-count'))
end

--saves the current playlist into a m3u file
function save_playlist()
    local savename = os.time().."-size_"..plen.."-playlist.m3u"
    local file = io.open(settings.filepath..savename, "w")
    if file==nil then
        print("Error in creating playlist file, check permissions and paths")
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

function sortplaylist()
    local length = tonumber(mp.get_property('playlist/count'))
    if length > 1 then
        local playlist = {}
        for i=0,length,1
        do
            playlist[i+1] = mp.get_property('playlist/'..i..'/filename')
        end
        table.sort(playlist)
        local first = true
        for index,file in pairs(playlist) do
            if first then 
                mp.commandv("loadfile", file, "replace")
                first=false
            else
                mp.commandv("loadfile", file, "append") 
            end
        end
    end
end

if settings.sortplaylist_on_start then
    mp.add_timeout(0.03, sortplaylist)
end

mp.add_key_binding('CTRL+p', 'sortplaylist', sortplaylist)
mp.add_key_binding('P', 'loadfiles', playlist)
mp.add_key_binding('p', 'saveplaylist', save_playlist)

mp.add_key_binding('UP', 'moveup', moveup)
mp.add_key_binding('DOWN', 'movedown', movedown)
mp.add_key_binding('CTRL+UP', 'moveprevup', moveprevup)
mp.add_key_binding('CTRL+DOWN', 'movenextdown', movenextdown)
mp.add_key_binding('Shift+UP', 'removecurrentfile', removecurrentfile)
mp.add_key_binding('Shift+DOWN', 'removenextfile', removenextfile)

mp.register_event('file-loaded', on_loaded)
