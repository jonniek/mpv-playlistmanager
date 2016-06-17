# Mpv-Playlistmanager
Mpv lua script to create and manage playlists. All parts work independently as long as on_loaded() and relevant variables from first rows are present, so if you want only certain features feel free to remove the others. Edit bottom rows of lua to change keybindings. Please notice that this script needs you to have `F9 show-text "${playlist}" 5000` in your input config, if you use another key for displaying playlist, please edit the lua code where F9 is present. I suggest using `--osd-playing-msg=${playlist}` in mpv.conf or none at all, otherwise it will interfere when managing playlist.
  
See demo of script in here: http://puu.sh/pwgzK/de7875be98.mp4

## Features
- Loadfiles(P)
  - Attempts to load all files after the currently playing file to the playlist
  - Ex. Open 5th file from a 12file directory, press P, the remaining 7 are loaded to playlist
  - Default is windows version, linux one is untested(lua row 66, uncomment if on linux, and comment windows out)
- Save playlist(p)
  - Saves the current playlist to m3u file, change filepath in lua to a path in your system
- Move up(UP)
  - Moves the currenly playing file backwards in the playlist queue
- Move down(DOWN)
  - Moves the currenly playing file forwards in the playlist queue
- Remove current file(Shift+UP)
  - Removes the currently playing file from the playlist, and resumes playing the next file
- Remove next file(Shift+DOWN)
  - Removes the file after currently playing file from playlist
  - This allows you to use currently playing file as a cursor to remove other files from playlist seamlessly
- Move next file up(CTRL+UP)
  - Moves the file after currently playing file forwards
  - This allows you to use currently playing file as a cursor to move other files in playlist seamlessly
- Move next file down(CTRL+DOWN)
  - Moves the file after currently playing file backwards
  - This allows you to use currently playing file as a cursor to move other files in playlist seamlessly

  
Leave me suggestions for new features!
