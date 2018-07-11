
// MARK: RetrieveCell Info



// MARK: Update CellInfo

    public func updateSensorPhoto(image: UIImage) {
        // Update Cell Data
        if let data = sensorData.value, let ip = self.indexPath {
            let sensorIconData: NSData = UIImagePNGRepresentation(image)! as NSData
            let formattedTemperature = data.sensorTemperature!.trimmingCharacters(in: TktConstants.CharSet.climateDigits.inverted)
            let formattedHumidity = data.sensorHumidity!.trimmingCharacters(in: TktConstants.CharSet.climateDigits.inverted)
            let formattedVOC = data.sensorVOC!.trimmingCharacters(in: TktConstants.CharSet.climateDigits.inverted)
            let formattedCO2 = data.sensorCO2!.trimmingCharacters(in: TktConstants.CharSet.climateDigits.inverted)
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
            
            let newData = sensorListCellData (
                sensorID: data.sensorID!,
                sensorIcon: image,
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
                showTHI: data.showTHI!,
                showTHINotif: data.showTHINotif!
            )
            
            self.coreDataManager.editSensor(indexPath: ip, icon: sensorIconData, name: data.sensorName!, type: data.sensorType!, temperature: temperature, humidity: formattedHumidity, voc: formattedVOC, co2: formattedCO2, decibel: formattedDecibel, lux: formattedLux, batteryLevel: data.sensorBatteryLevel!, period: data.sensorPeriod!, resetTimestamp: data.sensorResetTimeStamp!, firmwareVersion: data.sensorFirmwareVersion!, dateCreated: data.sensorDateCreated!, lastUpdated: data.sensorLastUpdated!, macAddress: data.sensorMacAddress!, uuid: data.sensorUUID!, cellData: newData, isFromEditingPhoto: true, upgradable: data.sensorIsUpgradable, showTHI: data.showTHI, showTHINotif: data.showTHINotif)
        }
    }
