//
//  File.swift
//  
//
//  Created by Hector Rodriguez on 10/04/24.
//

import Foundation

public protocol DeviceSessionDelegate: AnyObject {
    

    func deviceSession(_ deviceSessionClient: DeviceSessionClient, didFinishWithResult result: String)
    
}
