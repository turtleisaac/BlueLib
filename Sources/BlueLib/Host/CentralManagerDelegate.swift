//
//  CentralManagerDelegate.swift
//  BlueLib
//
//  Created by turtleisaac on 10/19/23.
//

import Foundation
import CoreBluetooth

class CentralManagerDelegate: NSObject, CBCentralManagerDelegate {
    
    let hostNode:HostNode
    
    init(hostNode: HostNode)
    {
        self.hostNode = hostNode
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("update state`")
        switch central.state {
        case .poweredOn:
            hostNode.startScan()
            break
        case .poweredOff:
            hostNode.stopScan()
            break
            // Alert user to turn on Bluetooth
        case .resetting:
            break
            // Wait for next state update and consider logging interruption of Bluetooth service
        case .unauthorized:
            break
            // Alert user to enable Bluetooth permission in app Settings
        case .unsupported:
            break
            // Alert user their device does not support Bluetooth and app will not work as expected
        case .unknown:
            break
            // Wait for next state update
        @unknown default:
            fatalError("kill me")
        }
    }
    
    /**
     This discovers the nearby devices
     */
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if !hostNode.discoveredPeripherals.contains(peripheral)
        {
            hostNode.discoveredPeripherals.append(peripheral)
            hostNode.peripheralData[peripheral] = PeripheralInfo(advertisementData: advertisementData, rssi: RSSI)
            hostNode.connect(peripheral: peripheral)
        }
    }
    
    /**
     This is ran after establishing a connection with a nearby device
     */
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        // Successfully connected. Store reference to peripheral if not already done.
        hostNode.connectedPeripherals.append(peripheral)
        peripheral.delegate = hostNode.peripheralDelegate
        peripheral.discoverServices([hostNode.serviceUUID])
    }
     
    /**
     This is ran after failing to establish a connection with a nearby device
     */
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        // Handle error
        print("failed to connect to \(peripheral.name!)")
        hostNode.connectedPeripherals.removeAll(where: {$0 == peripheral})
        hostNode.discoveredPeripherals.removeAll(where: {$0 == peripheral})
    }
    
    /**
     This is ran after ending the connection with a nearby device
     */
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        hostNode.connectedPeripherals.removeAll(where: {$0 == peripheral})
        hostNode.discoveredPeripherals.removeAll(where: {$0 == peripheral})
        if let error = error {
            // Handle error
            return
        }
        // Successfully disconnected
    }
}
