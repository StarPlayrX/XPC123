# XPC123 - How to write a XPC Launch Daemon using Swift

This repo includes an example XPC MachService that works between different apps.

I started with Apple's XPC Service template with Swift, the an XPCService plugin does not work with other applications. The reason XPC is usually needed is to communicate across different applications or processes. The prime example is two apps that need to simply talk to each other. This use case requires cross communication between two or more processes. A MachService allows any app, cli or process to use the service.

```
Apple's default template:
Application A <-> XPC Service plugin
Application B <-> Oh no!

A & B talking to themselves:
Application A <-> XPC Service plugin (Internal)
Application B <-> XPC Service plugin (Internal)
```


```
Alternative using a MachService:
Application A <-> XPC Launch Daemon (Systemwide)
Application B <-> XPC Launch Daemon (Systemwide)
```

```
You could combine the two like this:
Application A <-> XPC Service plugin <-> XPC Launch Daemon
Application B <-> XPC Service plugin <-> XPC Launch Daemon


Or use two embedded http servers:
Application A         <-> XPC Launch Daemon
Localhost http server B <-> Application B

Application B         <-> XPC Launch Daemon
Localhost http server A <-> Application A
```

As you can see Apple's example leads you to a dead end. In fact a XPC Launch Daemon has a one to many relationship vs. an XPCService plugin is one to one.

I've included both a service and a client. Tried to make this as easy as possible and kept it similar to Apple's XPCService Swift template for Applications / XPCService plugins. There is more to XPC, but having a working example makes it easier.

The MachService only works from a command line / headless app, not as a plugin. It do not have a UI. This means it needs to run as a LaunchDaemon. It also means it will be available system wide which is usually what you want. If you don't want it to be system wide and within the user space, this is where Launch Agents come into play.

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


