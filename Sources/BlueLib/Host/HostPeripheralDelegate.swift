//
//  PeripheralDelegate.swift
//  BlueLib
//
//  Created by turtleisaac on 10/19/23.
//

import Foundation
import CoreBluetooth

class HostPeripheralDelegate: NSObject, CBPeripheralDelegate {
    
    let hostNode:HostNode
    
    init(hostNode: HostNode)
    {
        self.hostNode = hostNode
    }
    
    /**
     This is ran after discovering the services of a peripheral
     */
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else {
            return
        }
        for service in services {
            peripheral.discoverCharacteristics(hostNode.characteristicUUIDs, for: service)
        }
    }
     
    
    /**
     This is ran after discovering the characteristics of a peripheral
     */
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else {
            return
        }
        // Consider storing important characteristics internally for easy access and equivalency checks later.
        // From here, can read/write to characteristics or subscribe to notifications as desired.
        guard let peripheralInfo = hostNode.peripheralData[peripheral] else {return}
//        peripheralInfo.characteristics[service] = characteristics
        peripheralInfo.characteristics = characteristics
        hostNode.communicationReadyAction()
    }
    
    
    /**
     this CAN be ran after discovering characteristics (not required) (for example, we could use this to broadcast what kind of data is contained within the characteristic (aka we could say it's a message, or that it's a direct message, or an image/gif )
     */
    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
        guard let descriptors = characteristic.descriptors else { return }
     
        // Get user description descriptor
        if let userDescriptionDescriptor = descriptors.first(where: {
            return $0.uuid.uuidString == CBUUIDCharacteristicUserDescriptionString
        }) {
            // Read user description for characteristic
            peripheral.readValue(for: userDescriptionDescriptor)
        }
    }
     
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor descriptor: CBDescriptor, error: Error?) {
        // Get and print user description for a given characteristic
        if descriptor.uuid.uuidString == CBUUIDCharacteristicUserDescriptionString,
            let userDescription = descriptor.value as? String {
            print("Characterstic \(descriptor.characteristic!.uuid.uuidString) is also known as \(userDescription)")
        }
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            // Handle error
            return
        }
        // Successfully subscribed to or unsubscribed from notifications/indications on a characteristic
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            // Handle error
            return
        }
                
        // do something with the data now
        hostNode.peripheralReadAction(peripheral, characteristic, error)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            // Handle error
            return
        }
        // Successfully wrote value to characteristic
    }
    
    func peripheralIsReady(toSendWriteWithoutResponse peripheral: CBPeripheral) {
        // Called when peripheral is ready to send write without response again.
        // Write some value to some target characteristic.
        
//        viewController.writeWait(value: data, characteristic: viewController.connectedPeripheralCharacteristics.last)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {
        hostNode.disconnect(peripheral: peripheral)
    }
}
