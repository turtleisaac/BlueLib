//
//  PeripheralNodeDelegate.swift
//  BlueLib
//
//  Created by turtleisaac on 4/3/24.
//

import Foundation
import CoreBluetooth

public protocol PeripheralNodeDelegate {
    func peripheralReceivedDataFromHost(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest])
}
