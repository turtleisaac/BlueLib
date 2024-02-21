//
//  PeripheralNode.swift
//  BlueLib
//
//  Created by turtleisaac on 10/20/23.
//

import Foundation
import CoreBluetooth

class PeripheralNode {
    private var peripheralManager: CBPeripheralManager!
    private var peripheralManagerDelegate: CBPeripheralManagerDelegate!
    
    var transferCharacteristic: CBMutableCharacteristic?
    
    let dataReceivedAction: (_ peripheral: CBPeripheralManager, _ requests: [CBATTRequest]) -> Void
    
//    var toPeripheralCharacteristic:CBMutableCharacteristic?
//    var fromPeripheralCharacteristic:CBMutableCharacteristic?
    
    let serviceUUID: CBUUID
    let characteristicUUIDs: [CBUUID]
    
    init(serviceUUID: CBUUID, characteristicUUIDs: [CBUUID], dataReceivedAction: @escaping (_ peripheral: CBPeripheralManager, _ requests: [CBATTRequest]) -> Void)
    {
        self.serviceUUID = serviceUUID
        self.characteristicUUIDs = characteristicUUIDs
        
        self.dataReceivedAction = dataReceivedAction
        
        peripheralManagerDelegate = PeripheralManagerDelegate(peripheralNode: self)
        peripheralManager = CBPeripheralManager(delegate: peripheralManagerDelegate, queue: nil, options: [CBPeripheralManagerOptionShowPowerAlertKey: true])
    }
    
    
    
    func setupPeripheral() {
        //todo come back and put these back
        var characteristics = [CBMutableCharacteristic]()
        
        for characteristicUUID in characteristicUUIDs {
            characteristics.append(CBMutableCharacteristic(type: characteristicUUID,
                                                             properties: [.notify, .writeWithoutResponse],
                                                             value: nil,
                                                             permissions: [.readable, .writeable]))
        }
        
        
        let messagingService = CBMutableService(type: serviceUUID, primary: true)
        messagingService.characteristics = characteristics
        
        peripheralManager.add(messagingService)
        
        // Save the characteristic for later.
//        self.toPeripheralCharacteristic = toPeripheralCharacteristic
//        self.fromPeripheralCharacteristic = fromPeripheralCharacteristic

    }
    
    func startAdvertising()
    {
        let advertisementData:[String: Any] = [
            CBAdvertisementDataServiceUUIDsKey: [serviceUUID]
        ]
        peripheralManager.startAdvertising(advertisementData)
    }
    
    func stopAdvertising()
    {
        peripheralManager.stopAdvertising()
    }
    
    func disable()
    {
        stopAdvertising()
        peripheralManager.removeAllServices()
    }
    
    /**
     send data from peripheral to connected host
     peripheral node is for when this device acts as the peripheral in the connection, so we should be writing the data to the "from peripheral" characteristic
     */
    func write(value: Data)
    {
        //todo come back and put this back
//        guard let fromPeripheralCharacteristic = fromPeripheralCharacteristic else {return}
//        peripheralManager.updateValue(value, for: fromPeripheralCharacteristic, onSubscribedCentrals: nil)
    }
}
