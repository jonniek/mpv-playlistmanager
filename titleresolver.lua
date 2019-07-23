
local utils = require("mp.utils")
-- resolve url title and send it back to playlistmanager
mp.register_script_message("resolveurltitle", function(filename)
  local args = { 'youtube-dl', '-sJ', filename}
  local res = utils.subprocess({ args = args })
  if res.status == 0 then
    local json, err = utils.parse_json(res.stdout)
    if not err then
      mp.commandv('script-message', 'playlistmanager', 'addurl', filename, json['title'])
    end
  end
end)
