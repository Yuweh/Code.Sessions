
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
                    
                    self.setChartDataEntry(datas: self.airQualityInfoViewModel.mTopYAxisData.value, chart: self.topChartView, tab: TktConstants.Key.attrTemperature)
                    self.setChartDataEntry(datas: self.airQualityInfoViewModel.mBottomYAxisData.value, chart: self.bottomChartView, tab: TktConstants.Key.attrHumidity)
                    self.setChartDataEntry(datas: self.airQualityInfoViewModel.mTHIYAxisData.value, chart: self.mChartTHI, tab: TktConstants.Key.attrTHI)
                    self.checkLimitLines(chart: self.topChartView)
                    self.checkLimitLines(chart: self.bottomChartView)
                    
                // For Co2 and VOC
                case 1:
                    self.thiChartStack.isHidden = true
                    
                    self.setChartInitializer(chart: self.topChartView, title: "\("VOC".localized)(\(TktConstants.Units.VOC))", isEnabled: true)
                    self.setChartInitializer(chart: self.bottomChartView, title: "\("CO2".localized)(\(TktConstants.Units.CO2))", isEnabled: true)
                    
//                    self.airQualityInfoViewModel.upperLimit = 0.0
//                    self.airQualityInfoViewModel.lowerLimit = 0.0
//
//                    self.topChartView.leftAxis.removeAllLimitLines()
//                    self.bottomChartView.leftAxis.removeAllLimitLines()
                    
                    if (Globals.isAirComfort()) {
                        // VOC AIRCOMFORT
                        self.setChartDataEntry(datas: self.airQualityInfoViewModel.mTopYAxisData.value, chart: self.topChartView, tab: TktConstants.Key.attrVOC)
                        
                        // CO2 AIRCOMFORT
                        self.setChartDataEntry(datas: self.airQualityInfoViewModel.mBottomYAxisData.value, chart: self.bottomChartView, tab: TktConstants.Key.attrCO2)
                    } else {
                        // DECIBEL AIRSENSOR
                        self.setChartDataEntry(datas: self.airQualityInfoViewModel.mTopYAxisData.value, chart: self.topChartView, tab: TktConstants.Key.attrDecibel)
                        
                        // LUX AIRSENSOR
                        self.setChartDataEntry(datas: self.airQualityInfoViewModel.mBottomYAxisData.value, chart: self.bottomChartView, tab: TktConstants.Key.attrLux)
                    }
                    //self.mChartTHI.setYAxisProperties(mActiveDataType: 4, minY: 70.0, maxY: 90.0, unit: unit)

                default:
                    return
                }
                
                // set Top & Bottom Charts
                //self.setChartData(datas: self.airQualityInfoViewModel.mTopYAxisData.value, chart: self.topChartView)
                //self.setChartData(datas: self.airQualityInfoViewModel.mBottomYAxisData.value, chart: self.bottomChartView)


    private func setChartDataEntry(datas: [Double], chart: ChartHelper, tab: String) {
        var chartDataEntry: [ChartDataEntry] = [ChartDataEntry]()
        
        for i in 0 ..< airQualityInfoViewModel.mTHIYAxisData.value.count {
            chartDataEntry.append(ChartDataEntry(x: airQualityInfoViewModel.mTimeStampData.value[i], y: datas[i]))
        }
        
        // Check if Value is less than or equal to Two
        if (airQualityInfoViewModel.mTHIYAxisData.value.count <= 2) {
            chartDataEntry = addFirstDataPoint(dataEntry: chartDataEntry)
        }
        
        let dataLineGraph: LineChartDataSet = LineChartDataSet(values: chartDataEntry, label: "")
        dataLineGraph.axisDependency = .left
        dataLineGraph.setColor(TktConstants.Color.AirComfort.GridBackgroundColor)
        dataLineGraph.lineWidth = 1.5
        dataLineGraph.fillAlpha = 65 / 255.0
        dataLineGraph.fillColor = TktConstants.Color.AirComfort.DataFillColor
        dataLineGraph.highlightColor = TktConstants.Color.AirComfort.PrimaryTextColor
        dataLineGraph.drawCirclesEnabled = false
        dataLineGraph.drawFilledEnabled = true
        dataLineGraph.fillFormatter = DataSetFillFormatter()
        
        var dataSets: [LineChartDataSet] = [LineChartDataSet]()
        dataSets.append(dataLineGraph)
        
        let data: LineChartData = LineChartData(dataSets: dataSets)
        data.setDrawValues(false)
        data.setValueTextColor(TktConstants.Color.AirComfort.GridBackgroundColor)
        
        chart.data = data
        chart.xAxis.valueFormatter = self.xAxisValueFormatter
        chart.xAxis.granularity = 1.0 // Set granularity always to reset xAxis Scale
        
        let unit = self.preferences.integer(forKey: TktConstants.Key.UnitPreference)
        
        switch tab {
        case TktConstants.Key.attrTemperature:
            let lLimit = self.tempLowerLimit ?? self.airQualityInfoViewModel.lowerLimit
            let uLimit = self.tempUpperLimit ?? self.airQualityInfoViewModel.upperLimit
            
            let min = [lLimit, datas.min()!.rounded()].min()!
            let max = [uLimit, datas.max()!.rounded()].max()!
            
            chart.changeData(lineChartData: data)
            chart.setYAxisProperties(mActiveDataType: 0, minY: min, maxY: max, unit: unit)
            
        case TktConstants.Key.attrHumidity:
            chart.changeData(lineChartData: data)
            chart.setYAxisProperties(mActiveDataType: 1, minY: 0.0, maxY: 100.0, unit: unit)
            
        case TktConstants.Key.attrTHI:
            
            let lLimit = data.getYMin()
            let uLimit = data.getYMax()
            
            let min = [lLimit, datas.min()!.rounded()].min()!
            let max = [uLimit, datas.max()!.rounded()].max()!
            
            chart.changeData(lineChartData: data)
            chart.setYAxisProperties(mActiveDataType: 4, minY: min, maxY: max, unit: unit)
            
        case TktConstants.Key.attrVOC:
            chart.leftAxis.axisMaximum = (self.airQualityInfoViewModel.mTopYAxisData.value.max()! >  TktConstants.Default.VOC_THRESHOLD_MAX)
                ? self.airQualityInfoViewModel.mTopYAxisData.value.max()! : TktConstants.Default.VOC_THRESHOLD_MAX
            chart.leftAxis.axisMinimum = 0.0
            
        case TktConstants.Key.attrCO2:
            chart.leftAxis.axisMaximum = (self.airQualityInfoViewModel.mBottomYAxisData.value.max())! > TktConstants.Default.CO2_THRESHOLD_MAX ? self.airQualityInfoViewModel.mBottomYAxisData.value.max()! : TktConstants.Default.CO2_THRESHOLD_MAX
            chart.leftAxis.axisMinimum = 100.0
            
        case TktConstants.Key.attrDecibel:
            chart.leftAxis.axisMinimum = 0.0
            chart.leftAxis.axisMaximum = 150.0
            
        case TktConstants.Key.attrLux:
            chart.leftAxis.axisMinimum = 0.0
            chart.leftAxis.axisMaximum = 1000.0
            
        default:
            return
        }
        
        if (chartSegmentedControl.selectedIndex == 1 || chartSegmentedControl.selectedIndex == 2) {
            // Zoom Chart for '1' == '7 Days' and '2' == 'Monthly' Tabs
            chart.zoomChart(numberOfDaysToZoom: 2)
            
        }
        
        if (data.entryCount < 30) {
            chart.animate(xAxisDuration: 0.5)
        } else {
            chart.animate(xAxisDuration: 1.0, easingOption: .linear)
        }
        
    }

