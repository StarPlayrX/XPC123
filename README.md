# XPC123 - How to write a XPC Launch Daemon using Swift

This repo includes an example XPC MachService that works between different apps.

I started with Apple's XPC Service template with Swift, the an XPCService plugin does not work with other applications. The reason XPC is usually needed is to communicate across different applications or processes. The prime example is two apps that need to simply talk to each other. This use case requires cross communication between two or more processes. A MachService allows any app, cli or process to use the service.

```
Apple's default template:
Application A <-> XPC Service A (Internal)
Application B <-> Oh no!

A & B talking to themselves:
Application A <-> XPC Service A (Internal)
Application B <-> XPC Service B (Internal)
```


```
Alternative using a MachService:
Application A <-> XPC Launch Daemon (Systemwide)
Application B <-> XPC Launch Daemon (Systemwide)
```

```
You could combine the two:
Application A <-> XPC Service A <-> XPC Launch Daemon
Application B <-> XPC Service B <-> XPC Launch Daemon
```
As you can see Apple's primary example leads you to a dead end. You could augment it with an embedded webserver on each side using Swifter or my fork SwifterLite, but that's more work. The alternative is to use a XPC Launch Daemon. It has a one to many relationship vs. an XPCService plugin which is only one to one.

I've included both a service and a client and made this example as easy as possible. It's nearly identical to Apple's XPCService Swift XPCService plugin. The main difference is an Application XPC Service vs. an XPC MachService.

The MachService is designed run an a LaunchDaemon. Daemons cannot have a UI which makes it ideal to use XPC. Daemons are also system wide and run as root. If you don't want this consider using this as a LaunchAgent instead within the Aqua session (not covered).

The MachClient can run in either a gui app or command line tool. This should also work with Authorization Plugins, but that hasn't been tested. 

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
# Plist permissions (required, needs to be run every time you update the plist)
sudo chown root:wheel /Library/LaunchDaemons/com.brusstodd.XPCMachService.plist

# Load outside of rebooting (good for testing your plist!)
sudo launchctl load -w /Library/LaunchDaemons/com.brusstodd.XPCMachService.plist

# Unload if needed 
sudo launchctl unload -w /Library/LaunchDaemons/com.brusstodd.XPCMachService.plist
```

Great discussion here on XPC MachServices
https://launchd-dev.macosforge.narkive.com/xYLsgYJR/the-machservice-key

Here are some examples combining XPC with a http webserver. This can reduce having using a timer or a watcher to check if a backend call as been sent. Embedded https servers interface with its hosting app. You may be able to do with with XPC only and if you do, I'd love to see your example. You might also be able to use Distributed Center Notifications posted the XPC Launch Daemon and observed by one of your apps.

```
Use two embedded http servers:
Application A <-> XPC Launch Daemon <-> Localhost http server B <-> Application B
Application B <-> XPC Launch Daemon <-> Localhost http server A <-> Application A
```

```
To fix the XPC Service dead end, this would work:
Application A <-> XPC Service A <-> Localhost http server B <-> Application B
Application B <-> XPC Service B <-> Localhost http server A <-> Application A
```

Hope this becomes useful to anyone wanting to use XPC across their own apps.
XPC easy as 123, XPC it's you and me!

