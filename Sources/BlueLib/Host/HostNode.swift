//
//  HostNode.swift
//  BlueLib
//
//  Created by turtleisaac on 10/20/23.
//

import Foundation
import CoreBluetooth

public class HostNode {
    
//    static let fromDeviceCharacteristicUUID = CBUUID(string: "5CE4B2A1-4A64-4A77-8C9C-81685385711D")
//    static let toDeviceCharacteristicUUID = CBUUID(string: "D382D5BC-EB87-4220-BF60-A8C9D6D32D51")
//    static let serviceUUID = CBUUID(string: "D574197B-5526-47B5-BA9D-B9019D2D31DD")
    
    private var centralManager: CBCentralManager!
    private var centralDelegate: CBCentralManagerDelegate!
    
    var peripheralDelegate: CBPeripheralDelegate!
    
    public var discoveredPeripherals = [CBPeripheral]() {
        didSet {
            peripheralDiscoveredAction()
        }
    }
    
    public var connectedPeripherals = [CBPeripheral]() {
        didSet {
            deviceConnectedAction()
        }
    }
    
    public var peripheralData: [CBPeripheral : PeripheralInfo]
    
    let peripheralDiscoveredAction: () -> Void
    let deviceConnectedAction: () -> Void
    let communicationReadyAction: () -> Void
    let peripheralReadAction: (_ peripheral: CBPeripheral, _ characteristic: CBCharacteristic, _ error: Error?) -> Void
    var peripheralDisconnectedAction: (_ peripheral: CBPeripheral) -> Void
    
    let serviceUUID: CBUUID
    let characteristicUUIDs: [CBUUID]
    
    public init(serviceUUID: CBUUID, characteristicUUIDs: [CBUUID], peripheralDiscoveredAction: @escaping () -> Void, deviceConnectedAction: @escaping () -> Void, communicationReadyAction: @escaping () -> Void, peripheralReadAction: @escaping (_ peripheral: CBPeripheral, _ characteristic: CBCharacteristic, _ error: Error?) -> Void)
    {
        self.serviceUUID = serviceUUID
        self.characteristicUUIDs = characteristicUUIDs
        
        self.deviceConnectedAction = deviceConnectedAction
        self.communicationReadyAction = communicationReadyAction
        self.peripheralReadAction = peripheralReadAction
        self.peripheralDiscoveredAction = peripheralDiscoveredAction
        self.peripheralDisconnectedAction = {_ in }
        peripheralData = [CBPeripheral : PeripheralInfo]()
        
        centralDelegate = CentralManagerDelegate(hostNode: self)
        peripheralDelegate = PeripheralDelegate(hostNode: self)
        centralManager = CBCentralManager(delegate: centralDelegate, queue: nil)
    }
    
    public func startScan() {
        print("started scan")
        centralManager.scanForPeripherals(withServices: [serviceUUID], options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
    }
    
    public func stopScan() {
        centralManager.stopScan()
    }
    
    func connect(peripheral: CBPeripheral) {
        centralManager.connect(peripheral, options: nil)
     }
    
    func disconnect(peripheral: CBPeripheral) {
        centralManager.cancelPeripheralConnection(peripheral)
        connectedPeripherals.removeAll(where: {$0 == peripheral})
        discoveredPeripherals.removeAll(where: {$0 == peripheral})
        peripheralDisconnectedAction(peripheral)
    }
    
    public func disconnectAll() {
        for peripheral in connectedPeripherals {
            disconnect(peripheral: peripheral)
        }
        connectedPeripherals.removeAll()
    }
    
    public func disable() {
        centralManager.stopScan()
        disconnectAll()
        discoveredPeripherals.removeAll()
    }
    
    
    
    // In main class
    // Call after connecting to peripheral
    func discoverServices(peripheral: CBPeripheral) {
        peripheral.discoverServices([serviceUUID])
    }
     
    // Call after discovering services
    func discoverCharacteristics(peripheral: CBPeripheral) {
        guard let services = peripheral.services else {
            return
        }
        for service in services {
            peripheral.discoverCharacteristics(characteristicUUIDs, for: service)
//            peripheral.discoverCharacteristics([HostNode.toDeviceCharacteristicUUID], for: service)
        }
    }
    
    //
    func discoverDescriptors(peripheral: CBPeripheral, characteristic: CBCharacteristic) {
        peripheral.discoverDescriptors(for: characteristic)
    }
    
    public func subscribeToNotifications(peripheral: CBPeripheral, characteristic: CBCharacteristic) {
        peripheral.setNotifyValue(true, for: characteristic)
     }
    
    func readValue(characteristic: CBCharacteristic) {
        self.connectedPeripherals.last?.readValue(for: characteristic)
    }
    
    /**
        send data from host to peripherals
        host node is for when this device acts as the host in the connection, so we should be writing the data to the "to peripheral" characteristic
     */
    func write(value: Data, characteristic: CBCharacteristic) {
//        self.connectedPeripheral?.writeValue(value, for: characteristic, type: .withResponse)
        // OR
        // self.connectedPeripheral?.maximumWriteValueLength(for: .withoutResponse)
        
        for peripheral in connectedPeripherals {
            peripheral.writeValue(value, for: characteristic, type: .withoutResponse)
        }
        
//       self.connectedPeripherals.last?.writeValue(value, for: characteristic, type: .withoutResponse)
     }
    
//    func writeWait(value: Data, characteristic: CBCharacteristic) {
//        if let peripheral = connectedPeripheral {
//            if peripheral.canSendWriteWithoutResponse {
//                self.connectedPeripheral?.writeValue(value, for: characteristic, type: .withoutResponse)
//            }
//        }
//    }
}
