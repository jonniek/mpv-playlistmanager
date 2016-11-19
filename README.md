# Mpv-Playlistmanager - REMADE  
Mpv lua script to create and manage playlists.
  
This is a remake of my earlier script that can be found in this repo in the [old folder](https://github.com/donmaiq/Mpv-Playlistmanager/tree/master/old).  
The reason for the remake is to make the playlist prettier, more convienient and more intuitive to use. Now the cursor is completely separate from the currently playing file making navigation easier.
  
![alt text](https://r.kyaa.sg/gzzvmd.gif "demo gif")

## Settings
You can modify behaviour of the scripts in the settings variable in the lua file or a `playlistmanager.conf`lua-setting file. Some of the settings are rather complex so it's better to edit them in the lua.

## Keybinds
#### Static keybindings
- __sortplaylist__(CTRL+p)  
  - Sorts the current playlist alphabetically. Stops currently playing file and starts playlist from start of new playlist. Option to run at mpv start automatically in settings.
- __loadfiles__(P)
  - Attempts to load all files after the currently playing file to the playlist from the currently playing files directory
  - Ex. Open 5th file from a 12file directory, press P, the remaining 7 are loaded to playlist
  - change boolean in settings for linux/windows
- __saveplaylist__(p)
  - Saves the current playlist to m3u file, change filepath in settings to a path in your system
- __showplaylist__(SHIFT+ENTER)
  - Displays the playlist and loads the dynamic keybinds for navigating
#### Dynamic keybindings
  - These keys will only work when playlist is visible, unless you specify otherwise in settings. The reason for this is that these keys are common for keybinds, but they are easiest to navigate with.
- __moveup__(UP)
  - Moves the cursor up in playlist, if at first entry loops to end of playlist.
- __movedown__(DOWN)
  - Moves the cursor down in playlist, if at last entry loops to start of playlist.
- __removefile__(Backspace)
  - Removes the file currently selected with the cursor from the playlist
- __jumptofile__(Enter)
  - Opens the file currently selected with the cursor, if cursor on playing file, jump to next file
- __tagcurrent__(CTRL+Up)
  - Selects the file under the cursor
  - When moving the cursor the selected file will follow, allowing reordering of the playlist

As you know you can override keybindings by their name in input.conf `ctrl+J script-binding jumptofile`
  

#### My other mpv scripts
- [unseen-playlistmaker](https://github.com/donmaiq/unseen-playlistmaker)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[manager+maker combined](https://github.com/donmaiq/unseen-playlistmaker/blob/master/unseen%2Bplaylistmanager.lua)
- [nextfile](https://github.com/donmaiq/mpv-nextfile)
- [Filenavigator](https://github.com/donmaiq/mpv-filenavigator)
