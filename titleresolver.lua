local utils = require("mp.utils")
local msg = require("mp.msg")
-- resolve url title and send it back to playlistmanager
mp.register_script_message("resolveurltitle", function(filename)
  local args = { 'youtube-dl', '--no-playlist', '--flat-playlist', '-sJ', filename }
  local req = mp.command_native_async({
                name = "subprocess",
                args = args,
                playback_only = false,
                capture_stdout = true
  }, function (success, res)
    if res.killed_by_us then
      msg.verbose('request to resolve url title ' .. filename .. ' timed out')
      return
    end

    if res.status == 0 then
      local json, err = utils.parse_json(res.stdout)
      if not err then
        local is_playlist = json['_type'] and json['_type'] == 'playlist'
        local title = (is_playlist and '[playlist]: ' or '') .. json['title']
        mp.commandv('script-message', 'playlistmanager', 'addurl', filename, title)
      else
        msg.error("Failed parsing json, reason: "..(err or "unknown"))
      end
    else
      msg.error("Failed to resolve url title "..filename.." Error: "..(res.error or "unknown"))
    end
  end
  )

  mp.add_timeout(5, function()
    mp.abort_async_command(req)
  end)
end)
