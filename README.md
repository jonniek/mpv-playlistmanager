# Mpv-Playlistmanager
Mpv lua script to create and manage playlists.

This script allows you to see and interact with your playlist in an intuitive way. The key features are removing, reordering and playing files. Additional features include resolving url titles, parsing filenames according to patterns and creating/saving/shuffling/sorting playlists.

![](playlistmanager.png)  
Default visual cues:  
○ default file  
▷ playing file  
● hovered file(for removing, playing and moving)  
▶ playing and hovered file  
➔ selected file(file is being moved)  
➤ playing and selected file  
It will make sense once you try the script!

## Settings
You can modify behaviour of the script in the settings variable in the lua file or a `playlistmanager.conf` lua-setting file. The configuration file should be placed in `script-opts` directory, not in `scripts`. Note: the conf file will override any
changed setting in the lua file. There is a playlistmanager.conf file in this repo with the default values of the script. You can also pass settings from the command line on startup such as `mpv --idle=once --script-opts=playlistmanager-loadfiles_on_start=yes`. Playlist saving feature will require you to set the `playlist_savepath` setting to a path in your system.

#### Url title resolving
If you want playlistmanager to fetch and display titles
of all playlist urls(mpv defaults to current file only) you will
need to use `prefer_titles = "url" or "all"`(defaults is "url") and also use
`titleresolver.lua` script found in this repository. The script
requires `youtube-dl` to be in PATH to work.

## Keybinds
#### Static keybindings
- __sortplaylist__(CTRL+p)  
  - Sorts the current playlist with stripped values from filename(not media title, no paths, usercreated strips applied). To start playlist from start you can use a script message `KEY script-message sortplaylist startover`. Settings involving sort include alphanumeric sort(nonpadded numbers in order, case insensitivity), sort on mpv start and sort on file added to playlist.  
- __shuffleplaylist__(CTRL+P)  
  - Shuffles the current playlist. Stops currently playing file and starts playlist from start of new playlist unlike native shuffle that doesn't shuffle current file.  
- __reverseplaylist__(CTRL+R)  
  - Reverses the current playlist. Does not stop playing the current file.  
- __loadfiles__(P)
  - Attempts to load all files from the currently playing files directory to the playlist keeping the order. Option to run at startup if 0 or 1 files are opened, with 0 opens files from working directory. On startup with no file requires `--idle=yes or --idle=once`.  
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
- __playfile__(Enter)
  - Opens the file currently selected with the cursor, if cursor on playing file, open the next file
- __selectfile__(RIGHT or LEFT)
  - Selects or unselects the file under the cursor
  - When moving the cursor the selected file will follow, allowing reordering of the playlist
- __unselectfile__(no default bind)
  - Unselects the file under the cursor if it was selected
- __closeplaylist__(ESC)
  - closes the playlist if it is open

Dynamic keybinds will only work when playlist is visible. There is a setting toggle to change them to static ones. You can override keybindings by their names above by adding the following in your input.conf `SPACE script-binding showplaylist`. However, Dynamic keybindings should be rebound in 
the settings to avoid overriding other conflicting keybinds and to support multiple keys per bind.
  
There is also a few script messages you can send to control the script:  
`KEY script-message playlistmanager command value value2`  
  
List of commands, values and their effects:  
  
Command | Value | Value2 | Effect
--- | --- | --- | ---
show | playlist | - / duration / toggle | show for default duration, show for given seconds, toggle playlist visibility
show | filename | - / seconds | shows stripped filename for default or set seconds
sort | startover | - | Sorts the playlist, any value will start playlist from start on sort
shuffle | - | - | Shuffles the playlist
reverse | - | - | Reverses the playlist
loadfiles | - / path | - | Loads files from playing files dir(default), or specified path
save | - | - | Saves the playlist
addurl | url | title | Binds a title to an url(used by titleresolver)
    
    
examples:  
`RIGHT playlist-next ; script-message playlistmanager show playlist` Shows the playlist after playlist-next  
`KEY show-text "Shuffled playlist" ; script-message playlistmanager shuffle` Text message on shuffle  
  

#### My other mpv scripts
- [collection of scripts](https://github.com/donmaiq/mpv-scripts)
