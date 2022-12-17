//
//  main.swift
//  XPCMachClient
//
//  Created by Todd Bruss on 12/17/22.
//

import Foundation

let xpcMesg = "xpc easy as 123, xpc it's you and me!"

let connectionToService = NSXPCConnection(machServiceName: "com.brusstodd.XPCMachService")

@objc protocol XPCServiceProtocol {
    func uppercase(string: String, with reply: @escaping (String) -> Void)
}

func connect() {
    connectionToService.remoteObjectInterface = NSXPCInterface(with: XPCServiceProtocol.self)
    connectionToService.resume()
}

func message() {
    if let proxy = connectionToService.remoteObjectProxy as? XPCServiceProtocol {
        proxy.uppercase(string: xpcMesg) { aString in
            NSLog("Result string was: \(aString)")
        }
    }
}

connect()
message()
sleep(2) // also you mini command line client to run til the end
//RunLoop.main.run()
