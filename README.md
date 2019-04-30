# countdown.sh
A shell countdown timer that I display in my [dwm status bar](https://github.com/joestandring/dotfiles).
## Features
* Creates a temporary file so the current status can be used in other scripts (e.g. a [dwm status bar](https://github.com/joestandring/dotfiles)).
* Alerts the user with a notification.
* Prevents multiple instances of the script running at once.
## Optional dependencies
* libnotify for notifications
## How to use
You can run countdown.sh with 3 arguments corresponding to hours, minutes, and seconds:
```
$ ./countdown.sh 1 30 5
1:30:5
1:30:4
1:30:3
...
```
Alternatively, if you run the script with less than 3 arguments, you will be prompted for the hours, minutes, and seconds:
```
$ ./countdown.sh
Hours: 1
Minutes: 30
Seconds: 5
1:30:5
1:30:4
1:30:3
...
```
