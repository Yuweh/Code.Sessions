
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


// Other Sample Func 

    public func sensorDataChanged(data: sensorListCellData) {
        if let ip = self.indexPath {
            let sensorIconData: NSData = UIImagePNGRepresentation(data.sensorIcon)! as NSData
            let formattedTemperature = data.sensorTemperature.trimmingCharacters(in: TktConstants.CharSet.climateDigits.inverted)
            let formattedHumidity = data.sensorHumidity.trimmingCharacters(in: TktConstants.CharSet.climateDigits.inverted)
            let formattedVOC = data.sensorVOC.trimmingCharacters(in: TktConstants.CharSet.climateDigits.inverted)
            let formattedCO2 = data.sensorCO2.trimmingCharacters(in: TktConstants.CharSet.climateDigits.inverted)
            let formattedDecibel = data.sensorDecibel!.trimmingCharacters(in: TktConstants.CharSet.climateDigits.inverted)
            let formattedLux = data.sensorLux!.trimmingCharacters(in: TktConstants.CharSet.climateDigits.inverted)
            
            var temperature = ""
            
            if preferences.object(forKey: TktConstants.Key.UnitPreference) != nil {
                let unit = preferences.integer(forKey: TktConstants.Key.UnitPreference)
                
                if (unit == 1) {
                    // Fahrenheit
                    if let fahrenheit = Float(formattedTemperature) {
                        let celsius = Globals.temperature2Celsius(fahrenheit: fahrenheit)
                        temperature = "\(celsius)"
                    }
                } else {
                    // Celsius
                    temperature = "\(formattedTemperature)"
                }
            } else {
                temperature = "\(formattedTemperature)"
            }
            
            let newData = sensorListCellData(
                sensorID: data.sensorID,
                sensorIcon: data.sensorIcon,
                sensorName: data.sensorName,
                sensorType: data.sensorType,
                sensorTemperature: data.sensorTemperature,
                sensorHumidity: data.sensorHumidity,
                sensorVOC: data.sensorVOC,
                sensorCO2: data.sensorCO2,
                sensorDecibel: data.sensorDecibel,
                sensorLux: data.sensorLux,
                sensorBatteryLevel: data.sensorBatteryLevel,
                sensorPeriod: data.sensorPeriod,
                sensorResetTimeStamp: data.sensorResetTimeStamp,
                sensorFirmwareVersion: data.sensorFirmwareVersion,
                sensorDateCreated: data.sensorDateCreated,
                sensorLastUpdated: data.sensorLastUpdated,
                sensorMacAddress: data.sensorMacAddress,
                sensorUUID: data.sensorUUID,
                sensorIsUpgradable: data.sensorIsUpgradable,
                showTHI: data.showTHI,
                showTHINotif: data.showTHINotif
            )
            
            // Check if we're going to write new values in Peripheral
            if let oldName = sensorData.value?.sensorName,
                let newName = data.sensorName,
                let oldPeriod = sensorData.value?.sensorPeriod,
                let newPeriod = data.sensorPeriod,
                let uuid = data.sensorUUID,
                let address = data.sensorMacAddress {
                
                if (oldName != newName || oldPeriod != newPeriod) {
                    doWriteNewProperties(uuid: uuid, name: newName, period: newPeriod, address: address)
                } else {
                    self.coreDataManager.editSensor(
                        indexPath: ip,
                        icon: sensorIconData,
                        name: data.sensorName,
                        type: data.sensorType,
                        temperature: temperature,
                        humidity: formattedHumidity,
                        voc: formattedVOC,
                        co2: formattedCO2,
                        decibel: formattedDecibel,
                        lux: formattedLux,
                        batteryLevel: data.sensorBatteryLevel,
                        period: data.sensorPeriod,
                        resetTimestamp: data.sensorResetTimeStamp,
                        firmwareVersion: data.sensorFirmwareVersion,
                        dateCreated: data.sensorDateCreated,
                        lastUpdated: data.sensorLastUpdated,
                        macAddress: data.sensorMacAddress,
                        uuid: data.sensorUUID,
                        cellData: newData,
                        isFromEditingPhoto: false,
                        upgradable: data.sensorIsUpgradable,
                        showTHI: data.showTHI,
                        showTHINotif: data.showTHINotif)
                }
            }
        }
    }
