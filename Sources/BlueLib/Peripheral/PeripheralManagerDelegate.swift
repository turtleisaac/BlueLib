//
//  PeripheralManagerDelegate.swift
//  BlueLib
//
//  Created by turtleisaac on 10/20/23.
//

import Foundation
import CoreBluetooth

class PeripheralManagerDelegate: NSObject, CBPeripheralManagerDelegate {
    
    let peripheralNode:PeripheralNode
    
    init(peripheralNode: PeripheralNode) {
        self.peripheralNode = peripheralNode
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case .poweredOn:
            // ... so start working with the peripheral
            peripheralNode.setupPeripheral()
            peripheralNode.startAdvertising()
            break;
        case .poweredOff, .resetting:
            peripheralNode.stopAdvertising()
            // In a real app, you'd deal with all the states accordingly
            return
        default:
            peripheralNode.stopAdvertising()
            // In a real app, you'd deal with yet unknown cases that might occur in the future
            return
        }
    }
    

    /// tells the delegate a remote central subscribed to a characteristic's value
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        return
    }
    
    /// tells the delegate a remote central unsubscribed from a characteristic's value
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFrom characteristic: CBCharacteristic) {
        return
    }
    
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        peripheralNode.dataReceivedAction(peripheral, requests)
    }
    
    func peripheralManagerIsReady(toUpdateSubscribers peripheral: CBPeripheralManager) {
        return
    }
}
