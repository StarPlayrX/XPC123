# XPC123

Made these example two apps of a mach service that works with both Application clients and command line utilities. 

Started with Apple's XPC Service template with Swift, but Apple's does not work with external applications making it a reason to abandon their approach.

By converting it to a mach service with very little code changes, this allows any app or cli to use the mach service.

I've included both a mach service and a client. Tried to make this as easy as possible and kept it similar to Apple's template.

I am sure there is much more to XPC than this, however having a working example on both the client and server makes it worth XPC gold.

Hope this becomes useful to anyone wanting to use XPC across their own apps. Enjoy!

Requirements:
The mach service seems to only work from a command line app / headless app, and not as a plugin. If you have anymore alternative uses, please file an issue or do a pull request. The Mach Client can run in either a gui app or command line tool. Most of the time, you'll run the mach service as a Launch Daemon, so this example is probably what you want to get starting using XPC.

XPC easy as 123, XPC it's you and me!


