# XPC123

Made these example two Swift apps of a XPC MachService that works with both Application clients and command line utilities. 

I started with Apple's XPC Service template with Swift, but Apple's example does not work with external applications making me question the value of that approach. The reason XPC is usually needed is to communicate across different applications or processes. A prime example is a bundle that may not have the ability to use entitlements but another application can. This use case requires cross communication between two or more processes. Converting it to a MachService with very little code changes, this allows any app or cli to use the service.

```
Apple's default template:
Application A <-> XPC Service plugin
Application B <-> Oh no!

A & B still can't communicate:
Application A <-> XPC Service plugin
Application B <-> XPC Service plugin
```


```
Alternative using a MachService:
Application A <-> XPC Launch Daemon 
Application B <-> XPC Launch Daemon 
```

```
You could combine the two using a middleware layer:
Application A <-> XPC Service plugin <-> XPC Launch Daemon
Application B <-> XPC Service plugin <-> XPC Launch Daemon
```

As you can see Apple's example leads you to a dead end. In fact a XPC Launch Daemon has a one to many relationship vs. Apple's XPC Service template using a plugin is only one to one.

I've included both a service and a client. Tried to make this as easy as possible and kept it similar to Apple's XPCService Swift template for Applications / XPCService plugins. I am sure there is much more to XPC than this. For me, having an end-to-end working example makes much easier to get started.

The MachService only works from a command line / headless app, not as a plugin. These do not have a UI. This means it needs to run as a LaunchDaemon. It also means it will be available system wide which is usually what you want. If you don't want it to be system wide and within the user space, this is where Launch Agents come into play.

The MachClient can run in either a gui app or command line tool. This should also work with Authorization Plugins, but that hasn't been tested. I will try to pass on more info on this soon.

Outside of Xcode, MachServices need to run as a LaunchDaemon. Apple allows MachServices to run in Xcode for testing and development purposes only. Here is some info on that: https://stackoverflow.com/questions/19881950/xpc-communication-between-service-and-client-app-works-only-when-launched-from-x

Example LaunchDaemon values. An example plist is included in the repo. Using Xcode, edit it to your liking.

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


Once you've edited the example plist, it will need to go in /Library/LaunchDaemons for launchd to start it. 

Permissions:
https://stackoverflow.com/questions/28063598/error-while-executing-plist-file-path-had-bad-ownership-permissions

```
# Permissions (required, needs to be run every time you update the plist)
sudo chown root:wheel /Library/LaunchDaemons/com.brusstodd.XPCMachService.plist

# Load outside of rebooting (good for testing your plist!)
sudo launchctl load /Library/LaunchDaemons/com.brusstodd.XPCMachService.plist

# Unload if needed 
sudo launchctl unload /Library/LaunchDaemons/com.brusstodd.XPCMachService.plist
```

Great discussion here on XPC MachServices
https://launchd-dev.macosforge.narkive.com/xYLsgYJR/the-machservice-key

Hope this becomes useful to anyone wanting to use XPC across their own apps.
XPC easy as 123, XPC it's you and me!


