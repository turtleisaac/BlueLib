//
//  BluetoothNodeDelegate.swift
//  BlueLib
//
//  Created by turtleisaac on 10/20/23.
//

import Foundation
import CoreBluetooth

public protocol BluetoothNodeDelegate {
    
    /// The below functions occur on the host/central side of things
    
    func deviceConnectedToHost()
    
    func hostReadyToCommunicate()
    
    func hostReceivedDataFromPeripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?)
    
    
    /// the below function occurs on the peripheral side of things
    
    func peripheralReceivedDataFromHost(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest])
}
