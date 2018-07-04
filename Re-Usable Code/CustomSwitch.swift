

    @IBAction func connectBtnPressed(_ sender: Any) {
        if deviceConnected {
            self.services.removeAll()
            self.connectedDeviceRSSI.text = "Device Disconnected"
            self.bluetoothBtn.setTitle("Connect?", for: .normal)
            self.bluetoothLogo.image = UIImage(named: "No.png")
            self.deviceConnected = false
            centralManager.cancelPeripheralConnection(peripheral)
            AlertBox(title: nil, message: "Your device is now disconnected".localized).show(self)
        } else if !deviceConnected {
            self.connectedDeviceRSSI.text = "Connection Restored "
            self.bluetoothBtn.setTitle("Disonnect?", for: .normal)
            self.bluetoothLogo.image = UIImage(named: "Yes.png")
            self.deviceConnected = true
            centralManager.connect(peripheral, options: nil)
            AlertBox(title: nil, message: "Your device is now connected".localized).show(self)
        }
    }
