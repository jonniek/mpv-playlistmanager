-- youtube-dl command, if it's not in PATH env use an absolute path
local youtubedl = 'youtube-dl.exe'
-- temporary file to store titles in
local tmpfile = os.getenv("USERPROFILE") .. '\\AppData\\Local\\Temp\\resolvedurls.txt'

local utils = require("mp.utils")
local processed_urls = {}
local resolved_urls = {}

mp.observe_property('playlist-count', "number", function()
  local length = mp.get_property_number('playlist-count', 0)
  if length < 2 then return end
  local i=0
  -- loop all items in playlist because we can't predict how it has changed
  while i < length do
    local filename = mp.get_property('playlist/'..i..'/filename')
    if filename:match('^https?://') and not processed_urls[filename] then
      processed_urls[filename] = true
      local args = {
        'powershell', '-NoProfile', '-Command', [[& {
            Trap {
                Write-Error -ErrorRecord $_
                Exit 1
            }
      
            $title = (]]..youtubedl..[[ --get-title ]]..filename..[[)
            Add-Content "]]..tmpfile..[[" "]]..filename..[[ $title"
        }]]
      }
      utils.subprocess_detached({args=args})
    end
    i=i+1
  end
end)

mp.add_periodic_timer(1, function()
  local file, e = io.open(tmpfile, 'r')
  if file then
    for line in file:lines() do
      local url, title = line:match("^(https?://.-)%s(.+)$")
      if not resolved_urls[url] and url and title then
        resolved_urls[url] = true
        mp.commandv("script-message", "playlistmanager", "addurl", url, title)
      end
    end
    file:close()
  end
end)

mp.register_event('shutdown', function()
  os.remove(tmpfile)
end)