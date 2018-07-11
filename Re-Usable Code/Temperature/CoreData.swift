
// MARK: RetrieveCell Info
        guard let data = self.sensorData else {
            return
        }


// MARK: Update CellInfo
    
    public func updateSensorShowTHI(showTHI: Int) {
        // Update Cell Data
        if let data = sensorData.value, let ip = self.indexPath {

            let showTHIEnabled: NSNumber = NSNumber(integerLiteral: showTHI)
            let sensorIconData: NSData = UIImagePNGRepresentation(data.sensorIcon)! as NSData
            let newData = sensorListCellData (
                sensorID: data.sensorID!,
                sensorIcon: data.sensorIcon!,
                sensorName: data.sensorName!,
                sensorType: data.sensorType!,
                sensorTemperature: data.sensorTemperature!,
                sensorHumidity: data.sensorHumidity!,
                sensorVOC: data.sensorVOC!,
                sensorCO2: data.sensorCO2!,
                sensorDecibel: data.sensorDecibel!,
                sensorLux: data.sensorLux!,
                sensorBatteryLevel: data.sensorBatteryLevel!,
                sensorPeriod: data.sensorPeriod!,
                sensorResetTimeStamp: data.sensorResetTimeStamp!,
                sensorFirmwareVersion: data.sensorFirmwareVersion!,
                sensorDateCreated: data.sensorDateCreated!,
                sensorLastUpdated: data.sensorLastUpdated!,
                sensorMacAddress: data.sensorMacAddress!,
                sensorUUID: data.sensorUUID!,
                sensorIsUpgradable: data.sensorIsUpgradable!,
                showTHI: showTHIEnabled,
                showTHINotif: data.showTHINotif!
            )
            
            self.coreDataManager.editSensor(indexPath: ip, icon: sensorIconData, name: data.sensorName, type: data.sensorType, temperature: data.sensorTemperature, humidity: data.sensorHumidity, voc: data.sensorVOC, co2: data.sensorCO2, decibel: data.sensorDecibel, lux: data.sensorLux, batteryLevel: data.sensorBatteryLevel, period: data.sensorPeriod, resetTimestamp: data.sensorResetTimeStamp, firmwareVersion: data.sensorFirmwareVersion, dateCreated: data.sensorDateCreated, lastUpdated: data.sensorLastUpdated, macAddress: data.sensorMacAddress, uuid: data.sensorUUID, cellData: newData, isFromEditingPhoto: false, upgradable: data.sensorIsUpgradable, showTHI: showTHIEnabled, showTHINotif: data.showTHINotif)
        }
    }
