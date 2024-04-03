//
//  BluetoothNode.swift
//  BlueLib
//
//  Created by turtleisaac on 10/20/23.
//

import Foundation
import CoreBluetooth

public class BluetoothNode {
    let hostNode: HostNode
    let peripheralNode: PeripheralNode
    
    let delegate:BluetoothNodeDelegate
    
    public init(delegate: BluetoothNodeDelegate, serviceUUID: CBUUID, characteristicUUIDs: [CBUUID])
    {
        self.delegate = delegate
        
        hostNode = HostNode(serviceUUID: serviceUUID, characteristicUUIDs: characteristicUUIDs, delegate: delegate)
        
        peripheralNode = PeripheralNode(serviceUUID: serviceUUID, characteristicUUIDs: characteristicUUIDs, delegate: delegate)
    }
}
