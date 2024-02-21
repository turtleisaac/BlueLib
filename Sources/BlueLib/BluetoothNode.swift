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
    let home:BluetoothHomeDelegate
    
    public init(delegate: BluetoothNodeDelegate, home: BluetoothHomeDelegate, serviceUUID: CBUUID, characteristicUUIDs: [CBUUID])
    {
        self.delegate = delegate
        self.home = home
        
        hostNode = HostNode(serviceUUID: serviceUUID, characteristicUUIDs: characteristicUUIDs, peripheralDiscoveredAction: home.peripheralDiscovered, deviceConnectedAction: delegate.deviceConnectedToHost, communicationReadyAction: delegate.hostReadyToCommunicate, peripheralReadAction: delegate.hostReceivedDataFromPeripheral(_:didUpdateValueFor:error:))
        
        peripheralNode = PeripheralNode(serviceUUID: serviceUUID, characteristicUUIDs: characteristicUUIDs, dataReceivedAction: delegate.peripheralReceivedDataFromHost(_:didReceiveWrite:))
    }
}
