## Windows platform screenshot taker

### How to configure the configuration file
```ini
[main]
// -= repeat_enable =-
// 0 = disable automatic repeat capturing screen
// 1 = enable automatic repeat  capturing screen
repeat_enable=0
// -= repeat_period =-
// repeat_period (seconds) works when repeat_enable = 1
repeat_period=5
// -= active_win_capture =-
// 1 = capture only active (focus) window
// 0 = capture entire screen
active_win_capture=1
// -= add_to_clipboard =-
// 1 = Also add captured screen buffer to clipboard
// 0 = Not add the captured screen buffer to clipboard
add_to_clipboard=1
// -= auto_mspaint =-
// 1 = Open MsPaint application after captured screen
// 0 = Not open MsPaint application after captured screen
auto_mspaint=0
// -= default shotkey is F9 {valid keys are F3-F10 and Ctrl+LeftClick and not same as opendirkey}
shotkey=Ctrl+LeftClick
// -= default openfolder key is F10 {valid keys are F3-F10 and not same as shotkey}
opendirkey=F10
// -= destination directory (default is D:\ScreenShotTakerOutput)
desdir=D:\ScreenShotTakerOutput

```

### How to use the application
1. Run the file 'ScreenShotTaker.exe'.
2. The application will run on background process and its icon reside at the right hand side task bar.
3. When done with using it, close the application by right click at its icon and click 'exit'.
