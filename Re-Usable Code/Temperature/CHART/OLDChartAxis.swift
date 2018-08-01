
        // MARK: Chart ULimits & LLimits
        
        _ = airQualityInfoViewModel.viewVariable.asObservable().subscribe { value in
            self.freezeControls()
            
            if (self.airQualityInfoViewModel.mTimeStampData.value.count > 0 &&
                0 < self.airQualityInfoViewModel.mTopYAxisData.value.count &&
                0 < self.airQualityInfoViewModel.mBottomYAxisData.value.count) {
                
                let unit = self.preferences.integer(forKey: TktConstants.Key.UnitPreference)
                
                switch self.dataTypeSegmentedControl.selectedIndex {
                // For Temp and Hum
                case 0:
                    self.thiChartStack.isHidden = self.isTHIChartHidden
                    let tempChartTitle = (self.preferences.integer(forKey: TktConstants.Key.UnitPreference) == 1) ? "\("temperature".localized)(\(TktConstants.Units.Fahrenheit))" : "\("temperature".localized)(\(TktConstants.Units.Celsius))"
                    
                    self.setChartInitializer(chart: self.topChartView, title: tempChartTitle, isEnabled: true)
                    self.setChartInitializer(chart: self.bottomChartView, title: "\("humidity".localized)(\(TktConstants.Units.Percent))", isEnabled: true)
                    self.setChartInitializer(chart: self.mChartTHI, title: "\("THI".localized)", isEnabled: true)
                    
                    if let templLimit = self.tempLowerLimit, let temphLimit = self.tempUpperLimit {
                        self.airQualityInfoViewModel.lowerLimit = templLimit
                        self.airQualityInfoViewModel.upperLimit = temphLimit
                    }
                    
                    if (self.preferences.integer(forKey: TktConstants.Key.UnitPreference) == 1) {
                        let maxArray: [Double] = [self.airQualityInfoViewModel.upperLimit, self.airQualityInfoViewModel.mTopYAxisData.value.max()!.rounded(), 100.0]
                        let minArray: [Double] = [self.airQualityInfoViewModel.lowerLimit, self.airQualityInfoViewModel.mTopYAxisData.value.min()!.rounded(), 50.0]
                        
                        self.topChartView.leftAxis.axisMaximum = maxArray.max()!
                        self.topChartView.leftAxis.axisMinimum = minArray.min()!
                        self.bottomChartView.leftAxis.axisMaximum = 100.0
                        self.bottomChartView.leftAxis.axisMinimum = 0.0
                    } else {
                        let maxArray: [Double] = [self.airQualityInfoViewModel.upperLimit, self.airQualityInfoViewModel.mTopYAxisData.value.max()!.rounded(), 40.0]
                        let minArray: [Double] = [self.airQualityInfoViewModel.lowerLimit, self.airQualityInfoViewModel.mTopYAxisData.value.min()!.rounded(), 10.0]
                        
                        self.topChartView.leftAxis.axisMaximum = maxArray.max()!
                        self.topChartView.leftAxis.axisMinimum = minArray.min()!
                        self.bottomChartView.leftAxis.axisMaximum = 100.0
                        self.bottomChartView.leftAxis.axisMinimum = 0.0
                    }
                    self.setChartData(datas: self.airQualityInfoViewModel.mTHIYAxisData.value, chart: self.mChartTHI)
                    self.mChartTHI.setYAxisProperties(mActiveDataType: 4, minY: 70.0, maxY: 90.0, unit: unit)
                    self.checkLimitLines(chart: self.topChartView)
                    self.checkLimitLines(chart: self.bottomChartView)
                    
                // For Co2 and VOC
                case 1:
                    self.thiChartStack.isHidden = true
                    
                    self.setChartInitializer(chart: self.topChartView, title: "\("VOC".localized)(\(TktConstants.Units.VOC))", isEnabled: true)
                    self.setChartInitializer(chart: self.bottomChartView, title: "\("CO2".localized)(\(TktConstants.Units.CO2))", isEnabled: true)
                    
                    self.airQualityInfoViewModel.upperLimit = 0.0
                    self.airQualityInfoViewModel.lowerLimit = 0.0
                    
                    self.topChartView.leftAxis.removeAllLimitLines()
                    self.bottomChartView.leftAxis.removeAllLimitLines()
                    
                    if (Globals.isAirComfort()) {
                        // VOC AIRCOMFORT
                        self.topChartView.leftAxis.axisMaximum = (self.airQualityInfoViewModel.mTopYAxisData.value.max()! >  TktConstants.Default.VOC_THRESHOLD_MAX)
                            ? self.airQualityInfoViewModel.mTopYAxisData.value.max()! : TktConstants.Default.VOC_THRESHOLD_MAX
                        self.topChartView.leftAxis.axisMinimum = 0.0
                        
                        // CO2 AIRCOMFORT
                        self.bottomChartView.leftAxis.axisMaximum = (self.airQualityInfoViewModel.mBottomYAxisData.value.max())! > TktConstants.Default.CO2_THRESHOLD_MAX ? self.airQualityInfoViewModel.mBottomYAxisData.value.max()! : TktConstants.Default.CO2_THRESHOLD_MAX
                        self.bottomChartView.leftAxis.axisMinimum = 100.0
                    } else {
                        // DECIBEL AIRSENSOR
                        self.topChartView.leftAxis.axisMinimum = 0.0
                        self.topChartView.leftAxis.axisMaximum = 150.0
                        
                        // LUX AIRSENSOR
                        self.bottomChartView.leftAxis.axisMinimum = 0.0
                        self.bottomChartView.leftAxis.axisMaximum = 1000.0
                        
                        
                    }
                        self.mChartTHI.setYAxisProperties(mActiveDataType: 4, minY: 70.0, maxY: 90.0, unit: unit)
                default:
                    return
                }
                
                // set Top & Bottom Charts
                self.setChartData(datas: self.airQualityInfoViewModel.mTopYAxisData.value, chart: self.topChartView)
                self.setChartData(datas: self.airQualityInfoViewModel.mBottomYAxisData.value, chart: self.bottomChartView)
                
            } else {
                self.clearChartData(chart: self.topChartView)
                self.clearChartData(chart: self.bottomChartView)
                self.clearChartData(chart: self.mChartTHI)
            }
            
            if (!self.activityIndicator.isHidden) {
                self.activityIndicator.isHidden = true
            }
            
            if (self.topChartView.isHidden && self.bottomChartView.isHidden) {
                self.topChartView.isHidden = false
                self.bottomChartView.isHidden = false
                self.mChartTHI.isHidden = false
            }
            }
            .addDisposableTo(disposeBag)
