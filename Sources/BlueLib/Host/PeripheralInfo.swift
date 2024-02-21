//
//  PeripheralWrapper.swift
//  BlueLib
//
//  Created by turtleisaac on 10/19/23.
//

import Foundation
import CoreBluetooth

public class PeripheralInfo{
    let advertisementData:[String : Any]
    let rssi:NSNumber
    
//    var characteristics: [CBService : [CBCharacteristic]]
    public var characteristics: [CBCharacteristic]
    
    init(advertisementData: [String : Any], rssi: NSNumber) {
        self.advertisementData = advertisementData
        self.rssi = rssi
        
//        characteristics = [CBService: [CBCharacteristic]]()
        characteristics = [CBCharacteristic]()

    }
}
