//
//  BLEManager.swift
//  SafeCycle
//
//  Created by Daniel Skendaj on 8/5/24.
//

import CoreBluetooth

class BluetoothManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    private var centralManager: CBCentralManager!
    private var peripheral: CBPeripheral?
    private var characteristic: CBCharacteristic?
    
    @Published var message = "Hello, Raspberry Pi!"
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            print("Central is powered on")
            centralManager.scanForPeripherals(withServices: [CBUUID(string: "12345678-1234-5678-1234-56789abcdef0")], options: nil)
        case .poweredOff:
            print("Central is powered off")
        case .resetting:
            print("Central is resetting")
        case .unauthorized:
            print("Central is unauthorized")
        case .unsupported:
            print("Central is unsupported")
        case .unknown:
            print("Central state is unknown")
        @unknown default:
            print("Central state is a new unknown case")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("Discovered peripheral: \(peripheral.name ?? "Unknown")")
        self.peripheral = peripheral
        self.peripheral?.delegate = self
        centralManager.stopScan()
        centralManager.connect(peripheral, options: nil)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to peripheral: \(peripheral.name ?? "Unknown")")
        peripheral.discoverServices([CBUUID(string: "12345678-1234-5678-1234-56789abcdef0")])
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            print("Error discovering services: \(error.localizedDescription)")
            return
        }
        if let services = peripheral.services {
            for service in services {
                print("Discovered service: \(service.uuid)")
                peripheral.discoverCharacteristics([CBUUID(string: "12345678-1234-5678-1234-56789abcdef1")], for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let error = error {
            print("Error discovering characteristics: \(error.localizedDescription)")
            return
        }
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                print("Discovered characteristic: \(characteristic.uuid)")
                if characteristic.uuid == CBUUID(string: "12345678-1234-5678-1234-56789abcdef1") {
                    self.characteristic = characteristic
                }
            }
        }
    }
    
    func sendMessage(_ message: String) {
        guard let characteristic = characteristic else {
            print("Characteristic not discovered yet")
            return
        }
        if let data = message.data(using: .utf8) {
            print("Sending message: \(message)")
            peripheral?.writeValue(data, for: characteristic, type: .withResponse)
        } else {
            print("Failed to convert message to data")
        }
    }
}
