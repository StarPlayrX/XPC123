# XPC123

Made these example two Swift apps of a MachService that works with both Application clients and command line utilities. 

Started with Apple's XPC Service template with Swift, but Apple's does not work with external applications making it a reason to abandon their approach. By converting it to a MachService with very little code changes, this allows any app or cli to use the service.

I've included both a service and a client. Tried to make this as easy as possible and kept it similar to Apple's XPCService Swift template for Applications / XPCService plugins. I am sure there is much more to XPC than this, however having an end-to-end working example makes it worth XPC gold.

Hope this becomes useful to anyone wanting to use XPC across their own apps. Enjoy!

The MachService seems to only work from a command line app / headless app, and not as a plugin. This means it needs to run as a LaunchDaemon which will make it system wide.

The MachClient can run in either a gui app or command line tool. This should also work with Authorization Plugins, but that hans't been officially tested yet and will be considered out of scope for now.

Outside of Xcode, MachServices need to run as a LaunchDaemon. Apple allows MachServices to run in Xcode for testing purposes only. Here is some info on that: https://stackoverflow.com/questions/19881950/xpc-communication-between-service-and-client-app-works-only-when-launched-from-x

Example LaunchDaemon plist. Will include this example Plist in the repo. 

```
{
    KeepAlive =     {
        SuccessfulExit = 0;
    };
    Label = "com.brusstodd.XPCMachService";
    LaunchOnlyOnce = 0;
    MachServices =     {
        "com.brusstodd.XPCMachService" = 1;
    };
    Program = "/Applications/XPCMachService";
    ProgramArguments =     (
        "/Applications/XPCMachService"
    );
    RunAtLoad = 1;
}
```


It will need to go in /Library/LaunchDaemons for launchd to start it. 

Permissions:
https://stackoverflow.com/questions/28063598/error-while-executing-plist-file-path-had-bad-ownership-permissions

```
# Permissions (required)
sudo chown root:wheel /Library/LaunchDaemons/myfile.plist

# Load outside of rebooting (good for testing purposes, otherwise test using Xcode)
sudo launchctl load /Library/LaunchDaemons/com.brusstodd.XPCMachService.plist

# Unload if needed 
sudo launchctl unload /Library/LaunchDaemons/com.brusstodd.XPCMachService.plist
```

Great discussion here on XPC MachServices
https://launchd-dev.macosforge.narkive.com/xYLsgYJR/the-machservice-key

XPC easy as 123, XPC it's you and me!


