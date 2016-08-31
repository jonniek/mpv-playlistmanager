# Mpv-Playlistmanager - REMADE  
Mpv lua script to create and manage playlists. Customize script in the settings array in the top of the lua file.  
  
This is a remake of my earlier script that can be found in this repo with the [_old suffix](https://github.com/donmaiq/Mpv-Playlistmanager/tree/master/old).  
The reason for the remake is to make the playlist prettier, more convienient and more intuitive to use.
  
![alt text](https://r.kyaa.sg/gzzvmd.gif "demo gif")


## Features
- __sort playlist__(CTRL+p)  
  - Sorts the current playlist alphabetically. Stops currently playing file and starts playlist from start of new playlist. Option to run at mpv start automatically in settings.
- __Loadfiles__(P)
  - Attempts to load all files after the currently playing file to the playlist from the currently playing files directory
  - Ex. Open 5th file from a 12file directory, press P, the remaining 7 are loaded to playlist
  - change boolean in settings for linux/windows
- __Save playlist__(p)
  - Saves the current playlist to m3u file, change filepath in settings to a path in your system
- __Move up__(UP)
  - Moves the cursor up in playlist, if at first entry loops to end of playlist.
- __Move down__(DOWN)
  - Moves the cursor down in playlist, if at first entry loops to start of playlist.
- __Show playlist__(SHIFT+ENTER)
  - Displays the playlist
- __Remove file__(Backspace)
  - Removes the file currently selected with the cursor from the playlist
- __Jump to file__(Enter)
  - Opens the file currently selected with the cursor, if cursor on playing file, jump to next file
- __Select file__(CTRL+Up)
  - Selects the file under the cursor
  - When moving the cursor the file with follow, allowing reordering of the playlist

  

#### My other mpv scripts
- [unseen-playlistmaker](https://github.com/donmaiq/unseen-playlistmaker)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[manager+maker combined](https://github.com/donmaiq/unseen-playlistmaker/blob/master/unseen%2Bplaylistmanager.lua)
- [nextfile](https://github.com/donmaiq/mpv-nextfile)
- [navigator](https://github.com/donmaiq/mpv-filenavigator)
