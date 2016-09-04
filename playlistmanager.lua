local settings = {

    --linux(true)/windows(false) toggle
    linux_over_windows = true,

    --path where you want to save playlists, notice trailing \ or /
    filepath = "$HOME/Documents/",

    --osd when navigating in seconds
    osd_duration_seconds = 5,

    --filetypes to search with (P), {*} for all, {'*mkv','*mp4'} for specific
    filetypes = {'*mkv','*mp4','*webm','*jpg','*gif','*png'},

    --sort playlist on mpv start
    sortplaylist_on_start = false,

    --attempt to strip path from the playlist filename, usually only nececcary if files have absolute paths
    --having it on true will cut out everything before the last / if it has one
    strip_paths = true,

    --show playlist every time a new file is loaded, will try to override any fileloaded conf
    show_playlist_on_fileload = false,
    
    --show playlist when selecting file within manager (ENTER)
    show_playlist_on_select = false,

    --sync cursor when file is loaded from outside reasons(file-ending, playlist-next shortcut etc.)
    --has the sideeffect of moving cursor if file happens to change when navigating
    --good side is cursor always following current file when going back and forth files with playlist-next/prev
    --2 is true, always follow on load 
    --1 is sticky, follow if cursor is close
    --0 is false, never follow
    sync_cursor_on_load = 2,

}

function on_loaded()
    mpvpath = mp.get_property('path')
    pos = tonumber(mp.get_property('playlist-pos'))
    plen = tonumber(mp.get_property('playlist-count'))
    path = string.sub(mp.get_property("path"), 1, string.len(mp.get_property("path"))-string.len(mp.get_property("filename")))
    file = mp.get_property("filename")
    
    search =' '
    for w in pairs(settings.filetypes) do
        if settings.linux_over_windows then
            search = search..string.gsub(path, "%s+", "\\ ")..settings.filetypes[w]..' '
        else
            search = search..'"'..path..settings.filetypes[w]..'" '
        end
    end

    if settings.sync_cursor_on_load==2 then
        cursor=pos
    elseif settings.sync_cursor_on_load==1 then
        if cursor == pos -1 then 
            cursor = cursor + 1 
        elseif cursor==pos+1 then
            cursor=cursor-1
        end
    end
    if settings.show_playlist_on_fileload then showplaylist(true) end
end

function strippath(pathfile)
    if settings.strip_paths then
        local tmp = string.match(pathfile, '.*/(.*)')
        if tmp then return tmp end
    end
    return pathfile 
end

cursor = 0
function showplaylist(delay)
    if delay then
        mp.add_timeout(0.2,showplaylist)
        return
    end
    if not mp.get_property('playlist-pos') or not mp.get_property('playlist-count') then return end
    pos = tonumber(mp.get_property('playlist-pos'))
    plen = tonumber(mp.get_property('playlist-count'))
    if cursor>plen then cursor=0 end
    local playlist = {}
    for i=0,plen-1,1
    do
        playlist[i] = strippath(mp.get_property('playlist/'..i..'/filename'))
    end
    if plen>0 then
        output = "Playing: "..mp.get_property('media-title').."\n\n"
        output = output.."Playlist - "..(cursor+1).." / "..plen.."\n"
        local b = cursor - 5
        if b > 0 then output=output.."...\n" end
        if b<0 then b=0 end
        for a=b,b+10,1 do
            if a == plen then break end
            if a == pos then output = output.."->" end
            if a == cursor then
                if tag then
                    output = output..">> "..playlist[a].." <<\n"
                else
                    output = output.."> "..playlist[a].." <\n"
                end
            else
                output = output..playlist[a].."\n"
            end
            if a == b+10 then
              output=output.."..."
            end
        end
    else
        output = file
    end
    mp.osd_message(output, settings.osd_duration_seconds)
end

tag=nil
function tagcurrent()
    if not tag then
        tag=cursor
    else
        tag=nil
    end
    showplaylist()
end

function removefile()
    tag = nil
    mp.commandv("playlist-remove", cursor)
    if cursor==plen-1 then cursor = cursor - 1 end
    showplaylist()
end

function moveup()
    if cursor~=0 then
        if tag then mp.commandv("playlist-move", cursor,cursor-1) end
        cursor = cursor-1
    else
        if tag then mp.commandv("playlist-move", cursor,plen) end
        cursor = plen-1
    end

    showplaylist()
end

function movedown()
    if cursor ~= plen-1 then
        if tag then mp.commandv("playlist-move", cursor,cursor+2) end
        cursor = cursor + 1
    else
        if tag then mp.commandv("playlist-move", cursor,0) end
        cursor = 0
    end
    showplaylist()
end

function jumptofile()
    tag = nil
    if cursor < pos then
        for x=1,math.abs(cursor-pos),1 do
            mp.commandv("playlist-prev", "weak")
        end
    elseif cursor>pos then
        for x=1,math.abs(cursor-pos),1 do
            mp.commandv("playlist-next", "weak")
        end
    else
        if cursor~=plen-1 then
            cursor = cursor + 1
        end
        mp.commandv("playlist-next", "weak")
    end
    if settings.show_playlist_on_select then
        showplaylist(true)
    end
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
    cursor=0
end

if settings.sortplaylist_on_start then
    mp.add_timeout(0.03, sortplaylist)
end

mp.add_key_binding('CTRL+p', 'sortplaylist', sortplaylist)
mp.add_key_binding('P', 'loadfiles', playlist)
mp.add_key_binding('p', 'saveplaylist', save_playlist)

mp.add_key_binding('Shift+ENTER', 'showplaylist', showplaylist)
mp.add_key_binding('UP', 'moveup', moveup)
mp.add_key_binding('DOWN', 'movedown', movedown)
mp.add_key_binding('CTRL+UP', 'tagcurrent', tagcurrent)
mp.add_key_binding('ENTER', 'jumptofile', jumptofile)
mp.add_key_binding('BS', 'removefile', removefile)

mp.register_event('file-loaded', on_loaded)
