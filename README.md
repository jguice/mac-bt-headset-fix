mac-bt-headset-fix <img src='https://travis-ci.org/jguice/mac-bt-headset-fix.svg?branch=master' alt='build status'/>
==================

Small mac application that fixes broken bluetooth headset control by listening for headset keypress events and re-triggers them as media key presses (as if one pushed the buttons on the keyboard).

The app should work with any player/etc. that responds to media keys, but allow you to use your bluetooth headset controls instead :-).

Download the [latest stable version](https://s3-us-west-2.amazonaws.com/jguice/mac-bt-headset-fix/Spotify+Bluetooth+Headset+Listener.zip).

## Usage
Download the above file and unzip it.  Double-click to run the app (you may need to generally allow unsigned apps or authorize this one in particular).

Try connecting your bluetooth device and pressing the play/pause/etc. buttons (press and hold too).  Your media player should respond to them just as if you'd pressed the relevant keyboard media key. :)

## What it does
On execution the application will background itself and listen for bluetooth headset events.  You'll see a **menu bar icon** that can be used to quit the app (or hide the menu icon).  **Note** *that the menu icon will remain visible for 30 seconds before hiding to allow changing the hide option or quitting, etc.*

The app will intercept common bluetooth headset key presses and re-fire them as media key presses.  Currently the following key presses are supported:

- play/pause
- next
- prev
- fast-forward
- rewind

The mapping on headsets seems to be a bit inconsistent.  If pressing next/prev doesn't work, try a press and hold. :)

On launch it will also attempt to unload the built-in Remote Control Daemon (rcd) which seems to be responsible for starting iTunes when a play event is first received.

**Note** *that this will probably cause any remote controls you use to stop working.*

If you find iTunes still loads you might try this [play-button-itunes-patch](http://github.com/thebitguru/play-button-itunes-patch).

## Quitting the Application when menu bar icon is hidden
If you've hidden the menu bar item then  you'll need to open the terminal and kill the process.  Try this:

- open the Terminal application (search spotlight or look in /Applications/Utilities)
- `ps ux | grep Bluetooth`

Look for a line that references **/Applications/Spotify Bluetooth Headset Listener.app** and starts with your username.

The number right after your username is the process id.

To quit (kill) the app type:  `kill [pid]`  where [pid] is the number from the previous step.

Then you can run the ps command again to verify it's no longer running.

 **Note** *on quit the application will try to reload the Remote Control Daemon to restore whatever functionality it provides*

## Beta Version

If you're feeling lucky try the [beta version](https://s3-us-west-2.amazonaws.com/jguice/mac-bt-headset-fix-beta/Spotify+Bluetooth+Headset+Listener.zip).

### Changes
- current beta is identical to the release version

## Origin
The original version of this app was posted on [this spotify community thread](http://community.spotify.com/t5/Help-Desktop-Linux-Mac-and/Bluetooth-headset-buttons/m-p/161796).  It controlled the spotify mac player directly via the scripting bridge (objC -> applescript).

I did not write it, but was granted permission to post it to github for sharing and encouraging enhancements.  It was published here under the [MIT License](http://opensource.org/licenses/MIT) as requested by the author. :)

This current version also retains that same license.

## Alternatives
 - https://github.com/JamesFator/BTHSControl

## Donations
Feel free to <a href="https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&amp;hosted_button_id=DT8G2EJMXLPLC">donate any amount</a> If you'd like to contribute to further development of this little app or just say "Thanks!"
