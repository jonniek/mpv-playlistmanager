
local utils = require("mp.utils")

-- resolve url title and send it back to playlistmanager
mp.register_script_message("resolveurltitle", function(filename)
  local res = utils.subprocess({ args = { "youtube-dl", "--get-title", filename } })
  if res.status == 0 then
    local title = res.stdout:gsub('\n', '')
    if (title ~= '') then
      mp.commandv("script-message", "playlistmanager", "addurl", filename, title)
    end
  end
end)
