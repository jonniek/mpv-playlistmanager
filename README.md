# Mpv-Playlistmanager
Mpv lua script to create and manage playlists

## Current features
- Loadfiles(P)
  - Attempts to load all files after the currently playing file to the playlist
  - Ex. Open 5th file from a 12file directory, press P, the remaining 7 are loaded to playlist
  - Default is windows version, linux one is untested
- Save playlist(p)
  - Saves the current playlist to m3u file, change filepath in lua to a path in your system
- Remove current file(F4)
  - Removes the currently playing file from the playlist
- Remove file(F5)
  - Removes the file after currently playing file from playlist
  - This allows you to use currently playing file as a cursor to remove other files from playlist seamlessly
- Move up(F6)
  - Moves the currenly playing file backwards in the playlist queue
- Move down(F7)
  - Moves the currenly playing file forwards in the playlist queue
- Move to end(F8)
  - Moves the currenly playing file to the end of the playlist and starts playing the next file

  
  
Leave me suggestions for features!
