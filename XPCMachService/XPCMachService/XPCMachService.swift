//
//  XPCMachService.swift
//  XPCMachService
//
//  Created by Todd Bruss on 12/16/22.
//

import Foundation

/// This object implements the protocol which we have defined. It provides the actual behavior for the service. It is 'exported' by the service to make it available to the process hosting the service over an NSXPCConnection.
class XPCMachService: NSObject, XPCMachServiceProtocol {
    
    /// This implements the example protocol. Replace the body of this class with the implementation of this service's protocol.
    @objc func uppercase(string: String, with reply: @escaping (String) -> (Void)) {
        let response = string.uppercased()
        reply(response)

    }
}
