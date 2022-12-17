# XPC123

Made these example two apps of a mach service that works with both Application clients and command line utilities. 

Started with Apple's XPC Service template with Swift, but Apple's does not work with external applications making it a reason to abandon their approach. By converting it to a mach service with very little code changes, this allows any app or cli to use the mach service.

I've included both a mach service and a client. Tried to make this as easy as possible and kept it similar to Apple's template. I am sure there is much more to XPC than this, however having a working example on both the client and server makes it worth XPC gold.

Hope this becomes useful to anyone wanting to use XPC across their own apps. Enjoy!

Requirements:
The mach service seems to only work from a command line app / headless app, and not as a plugin. If you have any additional uses like getting this to work as an XPC Service plugin/bundle but still works with external apps, please file an issue or do a pull request. 

The Mach Client can run in either a gui app or command line tool. Most of the time, you'll run the mach service as a Launch Daemon; more on that next.

Outside of Xcode, MachServices need to run as a LaunchDaemon.  Apple allows LaunchDaemon MachServices to run in Xcode for testing purposes only. Here is some info on that:

https://stackoverflow.com/questions/19881950/xpc-communication-between-service-and-client-app-works-only-when-launched-from-x

Example:

<img width="799" alt="image" src="https://user-images.githubusercontent.com/52664524/208255390-ce64d8e0-ada7-4ea8-8e75-6c6d038d1aa8.png">

XPC easy as 123, XPC it's you and me!


