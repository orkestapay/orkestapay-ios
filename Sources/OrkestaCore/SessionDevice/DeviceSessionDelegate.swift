//
//  File.swift
//  
//
//  Created by Hector Rodriguez on 10/04/24.
//

import Foundation

public protocol DeviceSessionDelegate: AnyObject {
    

    func sessionDevice(_ sessionDeviceClient: SessionDeviceClient, didFinishWithResult result: String)
    
}
