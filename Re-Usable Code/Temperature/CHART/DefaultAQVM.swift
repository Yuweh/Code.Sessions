


    public func generateChartData(from: NSNumber, to: NSNumber) {
        dispatchGroup.enter()
        DispatchQueue.global(qos: .utility).async {
            if let macAddress = self.sensorData.value?.sensorMacAddress {
                
                self.mTimeStampData.value.removeAll()
                self.mTopYAxisData.value.removeAll()
                self.mBottomYAxisData.value.removeAll()
                
                var yTopData: [Double] = []
                var yBottomData: [Double] = []
                var xTimestamp: [Double] = []
                
                let propertiesToFetch: [String] = [TktConstants.Key.attrTimestamp, TktConstants.Key.attrTemperature, TktConstants.Key.attrHumidity, TktConstants.Key.attrCO2, TktConstants.Key.attrVOC, self.attrToFetch]
                
                let data = self.coreDataManager.getDataBetweenTimestamp(macAddress: macAddress, sortKey: "timestamp", propertiesToFetch: propertiesToFetch, from: from, to: to)
                
                self.isFetchEmpty = (data.count > 0) ? false : true
                
                for d in data {
                    autoreleasepool {
                        switch self.attrToFetch {
                        case TktConstants.Key.tabTempAndHum:
                        if let temperature = d.value2, let humidity = d.value1, let timestamp = d.timestamp {
                            xTimestamp.append(Double(timestamp))
                            yBottomData.append(Double(humidity))
                            
                            if (self.preferences.object(forKey: TktConstants.Key.UnitPreference) != nil) {
                                let unit = self.preferences.integer(forKey: TktConstants.Key.UnitPreference)
                                if (unit == 1) {
                                    let celsius = Float(temperature)
                                    let fahrenheit = Globals.temperature2Fahrenheit(celsius: celsius)
                                    yTopData.append(Double(fahrenheit))
                                    return
                                }
                            }
                            yTopData.append(Double(temperature))
                        }
                        case TktConstants.Key.tabCo2AndVoc:
                            if let co2 = d.value3, let voc = d.value4, let timestamp = d.timestamp {
                                let doubleCo2 = Double(co2)
                                if (doubleCo2 == TktConstants.QualityLevels.Invalid) { return }
                                
                                yTopData.append(Double(voc))
                                yBottomData.append(doubleCo2)
                                xTimestamp.append(Double(timestamp))
                            }
                        case TktConstants.Key.tabDecibelAndLux:
                            if let decibel = d.value5, let lux = d.value6, let timestamp = d.timestamp {
                                
                                yTopData.append(Double(decibel))
                                yBottomData.append(Double(lux))
                                xTimestamp.append(Double(timestamp))
                            }
                        
                        default:
                            return
                        }
                    }
                }
                
                self.mTopYAxisData.value = yTopData
                self.mBottomYAxisData.value = yBottomData
                self.mTimeStampData.value = xTimestamp
                self.dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main, execute: {
            // Inform Chart that new Data is available in ViewController
            self.viewVariable.value = !self.viewVariable.value
        })
        
    }
    
