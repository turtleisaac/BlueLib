//
//  HostNodeDelegate.swift
//  BlueLib
//
//  Created by turtleisaac on 3/8/24.
//

import Foundation
import CoreBluetooth

public protocol HostNodeDelegate {
    
    /// The below functions occur on the host/central side of things
    
    func peripheralDiscovered()
    
    func deviceConnectedToHost()
    
    func hostReadyToCommunicate()
    
    func hostReceivedDataFromPeripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?)
    
    func peripheralDisconnectedFromHost(_ peripheral: CBPeripheral)
}
