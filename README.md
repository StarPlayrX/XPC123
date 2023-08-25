# XPC123 - How to write a XPC Launch Daemon using Swift

This repo includes an example XPC MachService that works between different apps.

I started with Apple's XPC Service template with Swift, the an XPCService plugin does not work with other applications. The reason to use XPC is to communicate across different applications or processes. The prime example is two apps that need to simply talk to each other. This use case requires cross communication between two or more processes. A MachService allows any app, cli or process to use the service.

```shell
# default Apple XPC template (no way in)
Application A <---> XPC Service A (Internal)
Application B <-/-> XPC Service A (dead end)
```

```shell
# A & B, own XPC Service (dead end)
Application A <-> XPC Service A (Internal)
Application B <-> XPC Service B (Internal)
```


```shell
# Alternative using a MachService (eureka)
Application A <-> XPC Launch Daemon (Systemwide)
Application B <-> XPC Launch Daemon (Systemwide)
```

```shell
# You could combine the two (separation)
Application A <-> XPC Service A <-> XPC Launch Daemon
Application B <-> XPC Service B <-> XPC Launch Daemon
```

As you can see Apple's primary example leads you to a dead end. The alternative is to use a XPC Launch Daemon. It has a one to many relationship. A XPC app plugin is one to one.

I've included both a service and a client and made this example as easy as possible. It's nearly identical to Apple's XPCService Swift XPCService plugin. The main difference is XPC123's example is a MachService instead of an Application owned XPC Service.

The MachService is designed run an a LaunchDaemon. Daemons cannot have a UI which makes it ideal to use XPC. Daemons are also system wide and run as root. If you don't want this consider using a LaunchAgent within the Aqua session aka user space. See launchd and launchctl for details.

The MachClient can run in either a gui app or command line tool. This should also work with Authorization Plugins. The later hasn't been tested. 

For software development and testing, Apple allows MachServices to run in Xcode for testing and development purposes. Outside of Xcode, MachServices need to run either as a LaunchDaemon or be launched using launchctl via a plist. Reference: https://stackoverflow.com/questions/19881950/xpc-communication-between-service-and-client-app-works-only-when-launched-from-x

Example LaunchDaemon values. An example plist is included in the repo. Use Xcode to edit the values.

```plist
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

```shell
# Plist permissions (required, needs to be run every time you update the plist)
sudo chown root:wheel /Library/LaunchDaemons/com.brusstodd.XPCMachService.plist

# Load outside of rebooting (good for testing your plist!)
sudo launchctl load -w /Library/LaunchDaemons/com.brusstodd.XPCMachService.plist

# Unload if needed 
sudo launchctl unload -w /Library/LaunchDaemons/com.brusstodd.XPCMachService.plist
```

Great discussion here on XPC MachServices
https://launchd-dev.macosforge.narkive.com/xYLsgYJR/the-machservice-key


### Interesting Out of Scope Things

Here is an example combining XPC with a http webserver. I recommend Swifter or fork SwifterLite. This can reduce having using a timer or a watcher to check if a backend call as been sent. You will have to use URLSession on the client side and include a common static http port. This is doable but more complicated and may require an http server on both side A and B.

```shell
# Use two embedded http servers to provide an alert mechanism
Application A <-> XPC Launch Daemon or XPC Service <-> Localhost http server B <-> Application B
Application B <-> XPC Launch Daemon or XPC Service <-> Localhost http server A <-> Application A
```

Another alternative would be to use the Network framework which is simple and easy to use. You may be able to do this with only XPC Service plugins plus the Network framework.
```shell
# To fix the XPC Service dead end, you add in the Network framework to bridge the gap
Application A <-> XPC Service A -> Network Sender A <-> Network Receiver B -> Application B
Application B <-> XPC Service B -> Network Sender B <-> Network Receiver A -> Application A
```

Since Launch Daemons are system wide, you should able to use Distributed Center Notifications posted by the XPC Launch Daemon and observed by one of your apps that the XPC launch daemon has some info for your other app. This is similar to how Network framework's p2p works.

tidbit on Protocols & exposing them to Objective-C @objc (required for protocols, but not for functions within the protocol)
https://stackoverflow.com/questions/52568409/cannot-convert-value-of-type-aprotocol-protocol-to-expected-argument-type-prot

Hope little repo is useful to anyone wanting to use XPC across their own apps.
