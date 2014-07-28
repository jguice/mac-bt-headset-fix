mac-bt-headset-fix
==================

Small mac application that fixes broken bluetooth headset control by listening for events and sending them directly to apps

## Origin
This little app was originally posted on [this spotify community thread](http://community.spotify.com/t5/Help-Desktop-Linux-Mac-and/Bluetooth-headset-buttons/m-p/161796).

I did not write it, but was granted permission to post it to github for sharing and encouraging enhancements.

It is published here under the [MIT License](http://opensource.org/licenses/MIT) as requested by the author. :)

## What it does
On execution the application will background itself and listen for bluetooth headset events.

Currently it responds to play/pause and next/previous.

It will translate those events into spotify actions (and thus requires the [spotify player](http://www.spotify.com/download) to be installed).

**Note** *that events will likely no longer work with iTunes.*

On launch it will also attend to unload the built-in Remote Control Daemon (rcd) which seems to be responsible for starting iTunes when a play event is first received.

**Note** *that this will probably cause any remote controls you use to stop working.*

If you find iTunes still loads you might try this [play-button-itunes-patch](http://github.com/thebitguru/play-button-itunes-patch).

## Usage
Download the [Spotify Bluetooth Headset Listener.zip](http://github.com/jguice/mac-bt-headset-fix/raw/master/Spotify%20Bluetooth%20Headset%20Listener.zip) file and unzip it.

Double-click to run the app (you may need to generally allow unsigned apps or authorize this one in particular).

Try connecting your bluetooth device and using the play/pause/etc. buttons.  Spotify should respond to them.  :)

## Quitting the Application
To "quit" the application you'll need to open the terminal and kill the process.  Try this:

- open the Terminal application (search spotlight or look in /Applications/Utilities)
- `ps ux | grep Bluetooth`

Look for a line that references **/Applications/Spotify Bluetooth Headset Listener.app** and starts with your username.

The number right after your username is the process id.

To quit (kill) the app type:  `kill [pid]`  where pid is the number from the previous step.

Then you can run the ps command again to verify it's no longer running.

 **Note** *on quit the application will try to reload the Remote Control Daemon to restore whatever functionality it provides*


## TODO
- instead of sending event directly to spotify, resend as keyboard media key event (which seems to work for many apps when bluetooth controls do not and will not disable iTunes events)
- if a general solution isn't possible, add support for other applications and a way to choose
- update the generic application icon
- provide a non-terminal way to quit the app (maybe a menu bar icon)

## Donations
If you'd like to contribute to further development of this little app or just say "Thanks!" ;)

<form action="https://www.paypal.com/cgi-bin/webscr" method="post" target="_top">
<input type="hidden" name="cmd" value="_s-xclick">
<input type="hidden" name="hosted_button_id" value="DT8G2EJMXLPLC">
<input type="image" src="https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif" border="0" name="submit" alt="PayPal - The safer, easier way to pay online!">
<img alt="" border="0" src="https://www.paypalobjects.com/en_US/i/scr/pixel.gif" width="1" height="1">
</form>
