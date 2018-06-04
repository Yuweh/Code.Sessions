//
//  ViewController.swift
//  Test01
//
//  Created by Jay Bergonia on 29/5/2018.
//

import UIKit
import CoreBluetooth

class MainViewController: UIViewController {
    
    @IBOutlet weak var MainLabel: UILabel!
    @IBOutlet weak var blueToothLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textView: UITextView!
    
    var centralManager: CBCentralManager!
    var isBluetoothPoweredOn: Bool = false
    var isScanning: Bool = false
    var scannedPeripheral: [String:Int] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    
    @IBAction func searchBtnPressed(_ sender: UIBarButtonItem) {
        
        //stop scanning
        if centralManager.isScanning {
            self.MainLabel.text = "Scanning Stopped"
            self.scannedPeripheral.removeAll()
            self.tableView.reloadData()
            centralManager.stopScan()
        } else {
            self.MainLabel.text = "Now Scanning"
            centralManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
        }
        
    }
    
    
    //Alert to Check if Bluetooth.isON
    func showAlertSettings() {
        let alert = UIAlertController(title: "Notice".localized, message: "Please turn on your Bluetooth", preferredStyle: .alert)
        let okay = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okay)
        self.present(alert, animated: true, completion: nil)
    }
    
    
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scannedPeripheral.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let deviceName = Array(scannedPeripheral.keys)[indexPath.row]
        let deviceSignal = Array(scannedPeripheral.values)[indexPath.row]
        cell.textLabel?.text = deviceName
        cell.detailTextLabel?.text = String(deviceSignal)
        
        self.MainLabel.text = String(scannedPeripheral.count) + " Devices Scanned"
        return cell
    }
    
}

extension MainViewController: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch (central.state) {
        case .poweredOn:
            blueToothLabel.text = "Bluetooth ON"
            blueToothLabel.textColor = UIColor.green
            isBluetoothPoweredOn = true
            break
        case .poweredOff:
            blueToothLabel.text = "Bluetooth OFF"
            blueToothLabel.textColor = UIColor.red
            isBluetoothPoweredOn = false
            showAlertSettings()
            break
        default:
            break
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if let advertisementName = advertisementData[CBAdvertisementDataLocalNameKey] as? String {
            self.scannedPeripheral[advertisementName] = Int(RSSI)
            tableView.reloadData()
        }
    }
}

extension MainViewController: CBPeripheralDelegate {
    
    
    
    
}




