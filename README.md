# Mpv-Playlistmanager
Mpv lua script to create and manage playlists.

This script allows you to see and interact with your playlist in an intuitive way. The key features are removing, reordering and playing files. Additional features include parsing filenames and creating/saving/shuffling/sorting playlists.

![preview gif](https://giant.gfycat.com/GreatDelayedAlligator.gif)  
Default visual cues:  
▷ - playing file  
▶ - playing and selected file  
● - selected file(for removing, playing and moving)  
● = lifted file(file is being moved)  
○ - rest of the files  

## Settings
You can modify behaviour of the script in the settings variable in the lua file or a `playlistmanager.conf`lua-setting file. Some of the settings are rather complex so it's better to edit them in the lua. Saveplaylist will require you to set the path in settings variable to a path in your system(on windows escape every backslash with a backslash).

## Keybinds
#### Static keybindings
- __sortplaylist__(CTRL+p)  
  - Sorts the current playlist alphanumerically(file1-file100 in correct order, wip since some naming conventions still fail). Stops currently playing file and starts playlist from start of new playlist. Option to run at mpv start automatically in settings.  
- __shuffleplaylist__(CTRL+P)  
  - Shuffles the current playlist. Stops currently playing file and starts playlist from start of new playlist unlike native shuffle that doesnt shuffle current file.  
- __loadfiles__(P)
  - Attempts to load all files from the currently playing files directory to the playlist keeping the order. Much like [autoload](https://github.com/mpv-player/mpv/blob/master/TOOLS/lua/autoload.lua) 
- __saveplaylist__(p)
  - Saves the current playlist to m3u file, change filepath in settings to a path in your system
- __showplaylist__(SHIFT+ENTER)
  - Displays the current playlist and loads the dynamic keybinds for navigating  
  
#### Dynamic keybindings
- __moveup__(UP)
  - Moves the cursor up in playlist, if at first entry loops to end of playlist.
- __movedown__(DOWN)
  - Moves the cursor down in playlist, if at last entry loops to start of playlist.
- __removefile__(Backspace)
  - Removes the file currently selected with the cursor from the playlist
- __jumptofile__(Enter)
  - Opens the file currently selected with the cursor, if cursor on playing file, jump to next file
- __tagcurrent__(RIGHT)
  - Selects or unselects the file under the cursor
  - When moving the cursor the selected file will follow, allowing reordering of the playlist

Dynamic keybinds will only work when playlist is visible. There is a setting toggle to change them to static ones. The reason for the dynamic keybinds is that many people and scripts want to use arrow keys so overriding them only when using the playlist is more convienient. You can override keybindings by their names above by adding the following in your input.conf `ctrl+J script-binding jumptofile`  
  
  
There is alsoa few script messages you can send to control the script:  
`KEY script-message playlistmanager command value value2`  
  
List of commands, values and their effects:  
  
Command | Value | Value2 | Effect
--- | --- | --- | ---
show | playlist / filename | - / seconds | shows playlist / stripped filename for default or set seconds
sort | - | - | Sorts the playlist
shuffle | - | - | Shuffles the playlist
loadfiles | - | - | Loads files from directory
save | - | - | Saves the playlist
    
    
examples:  
`RIGHT playlist-next ; script-message playlistmanager show playlist 3` Shows the playlist for 3 seconds after playlist-next  
`KEY show-text "Shuffled playlist" ; script-message playlistmanager shuffle` Text message on shuffle  
  
#### My other mpv scripts
- [collection of scripts](https://github.com/donmaiq/mpv-scripts)
