
    // RxSwift
    
    var mTopYAxisData: Variable<[Double]> = Variable([])
    var mBottomYAxisData: Variable<[Double]> = Variable([])
    var mTimeStampData: Variable<[Double]> = Variable([])
    
    var mTHIYAxisData: Variable<[Double]> = Variable([])
    
    
    // Data Generator for Chart     
    public func generateData(from: NSNumber, to: NSNumber) {
        dispatchGroup.enter()
        DispatchQueue.global(qos: .utility).async {
            if let macAddress = self.sensorData.value?.sensorMacAddress {
                
                self.mTimeStampData.value.removeAll()
                self.mTopYAxisData.value.removeAll()
                self.mBottomYAxisData.value.removeAll()
                self.mTHIYAxisData.value.removeAll() //THI RxVariable cleared
                
                var yTopData: [Double] = []
                var yBottomData: [Double] = []
                var xTimestamp: [Double] = []
                var xTHIData: [Double] = []
                
                let propertiesToFetch: [String] = [TktConstants.Key.attrTimestamp, TktConstants.Key.attrTemperature, TktConstants.Key.attrHumidity]
                
                let data = self.coreDataManager.getDataBetweenTimestamp(macAddress: macAddress, sortKey: "timestamp", propertiesToFetch: propertiesToFetch, from: from, to: to)
                
                self.isFetchEmpty = (data.count > 0) ? false : true
                
                for d in data {
                    autoreleasepool {
                        if let temperature = d.value2, let humidity = d.value1, let timestamp = d.timestamp {
                            xTimestamp.append(Double(timestamp))
                            yBottomData.append(Double(humidity))
                            
                            if (self.preferences.object(forKey: TktConstants.Key.UnitPreference) != nil) {
                                let unit = self.preferences.integer(forKey: TktConstants.Key.UnitPreference)
                                
                                if (unit == 1) {
                                    let celsius = Float(temperature)
                                    let fahrenheit = Globals.temperature2Fahrenheit(celsius: celsius)
                                    yTopData.append(Double(fahrenheit))
                                    
                                    // compute THI Value for Graph Array
                                    let thiValueF = ThiHelper.computeTHIValue(value: fahrenheit, humidity: Float(humidity), unit: 1)
                                    xTHIData.append(Double(thiValueF)) //append to thiTempArray 1
                                    return
                                }
                            }
                            
                            yTopData.append(Double(temperature))
                            let thiValueC = ThiHelper.computeTHIValue(value: fahrenheit, humidity: Float(humidity), unit: 0)
                            xTHIData.append(Double(thiValueC)) //append to thiTempArray 0
                        }
                    }
                }
                
                
                
                self.mTopYAxisData.value = yTopData
                self.mBottomYAxisData.value = yBottomData
                self.mTimeStampData.value = xTimestamp
                
                self.mTHIYAxisData.value = xTHIData //mTHIYAxisData
                
                self.dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main, execute: {
            // Inform Chart that new Data is available in ViewController
            self.viewVariable.value = !self.viewVariable.value
        })
        
    }
