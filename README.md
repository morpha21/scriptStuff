# scriptStuff
These are just some scripts I did for my personal use, for automating simple tasks, learning and testing things. Since most of them are very short, I guess it's better to put them all 
together in a single repository. There they are.


### removeZips
Removes .zip files from a directory in which exists folders with the same name as the .zip files. It was originally written in Bash, and then also in Go.

### brilhante
Changes the screen brightness on hardware level on my laptop. I use no Desktop 
Environment (such as KDE or XFCE or GNOME) on my openSUSE installation, I use just 
bspwm (a tiling window manager) instead. Brightness keys on my keyboard weren't 
working out of the box, so I had to write brilhante.sh and configure "brilhante.sh 
mais" and "brilhante.sh menas" as keyboard shortcuts, putting them on a path 
directory and using sxhkd to call them by pressing the keys I wanted. For study 
purpose, I made brilhante.go to accomplish the same task.

### battery.sh
While running on background, it checks battery levels and uses dunst and 
notify-send to notify user about the battery level of the system. If it is bellow 
28% (a number I like), it notifies the user from 2 to 2 minutes. If it is 
bellow 6% (another number I like), it notifies the user about critical battery 
level and turns off the system in one minute and a half if battery is not charging. 
