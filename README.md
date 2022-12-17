# XPC123

Made these example two Swift apps of a MachService that works with both Application clients and command line utilities. 

Started with Apple's XPC Service template with Swift, but Apple's does not work with external applications making it a reason to abandon their approach. By converting it to a MachService with very little code changes, this allows any app or cli to use the service.

I've included both a service and a client. Tried to make this as easy as possible and kept it similar to Apple's template. I am sure there is much more to XPC than this, however having a working example on both the client and server makes it worth XPC gold.

Hope this becomes useful to anyone wanting to use XPC across their own apps. Enjoy!

Requirements:
The MachService seems to only work from a command line app / headless app, and not as a plugin. If you have any additional uses like getting this to work as an XPC Service plugin/bundle but still works with external apps, please file an issue or do a pull request. 

The MachClient can run in either a gui app or command line tool. Most of the time, you'll run the service as a Launch Daemon; more on that next. This should also work with Authorization Plugins, but that hans't been officially tested yet and will be considered out of scope for now.

Outside of Xcode, MachServices need to run as a LaunchDaemon.  Apple allows LaunchDaemon MachServices to run in Xcode for testing purposes only. Here is some info on that: https://stackoverflow.com/questions/19881950/xpc-communication-between-service-and-client-app-works-only-when-launched-from-x

Example LaunchDaemon plist. Will give a more practical example soon. 

<img width="799" alt="image" src="https://user-images.githubusercontent.com/52664524/208255390-ce64d8e0-ada7-4ea8-8e75-6c6d038d1aa8.png">

It will need to go in /Library/LaunchDaemons for launchd to start it. 

Great discussion here on XPC MachServices
https://launchd-dev.macosforge.narkive.com/xYLsgYJR/the-machservice-key

XPC easy as 123, XPC it's you and me!


