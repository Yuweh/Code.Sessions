
        static let tabTempAndHum: String = "tab01"
        static let tabCo2AndVoc: String = "tab02"
        static let tabDecibelAndLux: String = "tab03"

    @IBOutlet weak var topChartView: ChartHelper!
    @IBOutlet weak var bottomChartView: ChartHelper!
    
            // MARK: Exp - ULimits & LLimits
        
        _ = airQualityInfoViewModel.viewVariable.asObservable().subscribe { value in
            self.freezeControls()
            
            if (self.airQualityInfoViewModel.mTimeStampData.value.count > 0 && 0 < self.airQualityInfoViewModel.mTopYAxisData.value.count && 0 < self.airQualityInfoViewModel.mBottomYAxisData.value.count) {
                switch self.dataTypeSegmentedControl.selectedIndex {
                // For Temp and Hum
                case 0:
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
                    
                    self.checkLimitLines(chart: self.topChartView)
                    self.checkLimitLines(chart: self.bottomChartView)
                    
                // For Co2 and VOC
                case 1:
                    self.airQualityInfoViewModel.upperLimit = 0.0
                    self.airQualityInfoViewModel.lowerLimit = 0.0
                    
                    if (Globals.isAirComfort()) {
                        // VOC AIRCOMFORT
                        self.topChartView.leftAxis.axisMaximum = (self.airQualityInfoViewModel.mTopYAxisData.value.max()! >  TktConstants.Default.VOC_THRESHOLD_MAX)
                            ? self.airQualityInfoViewModel.mTopYAxisData.value.max()! : TktConstants.Default.VOC_THRESHOLD_MAX
                        self.topChartView.leftAxis.axisMinimum = 0.0
                        
                        // CO2 AIRCOMFORT
                        self.bottomChartView.leftAxis.axisMaximum = (self.airQualityInfoViewModel.mBottomYAxisData.value.max()! >  TktConstants.Default.CO2_THRESHOLD_MAX) ? self.airQualityInfoViewModel.mBottomYAxisData.value.max()! : TktConstants.Default.CO2_THRESHOLD_MAX
                        self.bottomChartView.leftAxis.axisMinimum = 100.0
                        
                    } else {
                        // DECIBEL AIRSENSOR
                        self.topChartView.leftAxis.axisMinimum = 0.0
                        self.topChartView.leftAxis.axisMaximum = 150.0
                        
                        // LUX AIRSENSOR
                        self.bottomChartView.leftAxis.axisMinimum = 0.0
                        self.bottomChartView.leftAxis.axisMaximum = 1000.0
                    }
                    
                    self.checkLimitLines(chart: self.topChartView)
                    self.checkLimitLines(chart: self.bottomChartView)
                    
                default:
                    return
                }
                
                //self.displayChartData(datas: self.airQualityInfoViewModel.xAxisLabels.value)
                // set Top & Bottom Charts
                self.setChartData(datas: self.airQualityInfoViewModel.mTopYAxisData.value, chart: self.topChartView)
                self.setChartData(datas: self.airQualityInfoViewModel.mBottomYAxisData.value, chart: self.bottomChartView)
                
            } else {
                self.clearChartData(chart: self.topChartView)
                self.clearChartData(chart: self.bottomChartView)
//                self.lineChartView.noDataText = (!self.airQualityInfoViewModel.isFetchEmpty) ? NSLocalizedString("no_data_available_text", comment: "") : NSLocalizedString("no_data_text", comment: "")
            }
            
            if (!self.activityIndicator.isHidden) {
                self.activityIndicator.isHidden = true
            }

            if (self.topChartView.isHidden && self.bottomChartView.isHidden) {
                self.topChartView.isHidden = false
                self.bottomChartView.isHidden = false
            }
            }
            .addDisposableTo(disposeBag)
    }
    
        private func formatChart(chart: LineChartView) {
        self.xAxisValueFormatter = DynamicXAxisFormatter(chart: chart)
        self.dataSetFillFormatter = DataSetFillFormatter()
        chart.delegate = self
        chart.gridBackgroundColor = (Globals.isAirComfort()) ? TktConstants.Color.AirComfort.GridBackgroundColor : TktConstants.Color.AirSensor.GrayTextColor
        chart.noDataText = NSLocalizedString("no_data_text", comment: "")
        chart.noDataFont = UIFont(name: "Antenna-Light", size: 11)!
        chart.noDataTextColor = (Globals.isAirComfort()) ? TktConstants.Color.AirComfort.PrimaryTextColor : TktConstants.Color.AirSensor.GrayTextColor
        chart.xAxis.setLabelCount(5, force: false)
        chart.xAxis.labelPosition = .bottom
        chart.xAxis.axisLineWidth = 2.0
        chart.chartDescription?.text = ""
        chart.xAxis.labelFont = UIFont(name: "Antenna-Light", size: 9)!
        chart.xAxis.granularityEnabled = true
        chart.getAxis(.left).labelFont = UIFont(name: "Antenna-Light", size: 9)!
        chart.getAxis(.left).axisLineWidth = 2.0
        chart.getAxis(.left).granularityEnabled = true
        chart.getAxis(.left).granularity = 1.0
        chart.getAxis(.left).decimals = 0
        chart.rightAxis.enabled = false
        chart.legend.enabled = false
    }
    
    private func clearChartData(chart: LineChartView) {
        chart.data = nil
        chart.xAxis.valueFormatter = nil
        chart.animate(xAxisDuration: 1.0, easingOption: .easeInCubic)
        chart.noDataText = (!self.airQualityInfoViewModel.isFetchEmpty) ? NSLocalizedString("no_data_available_text", comment: "") : NSLocalizedString("no_data_text", comment: "")
    }
    
    private func setTopChartData(datas: [Double], tab: String) {
        var chartDataEntry: [ChartDataEntry] = [ChartDataEntry]()
        
        for i in 0 ..< airQualityInfoViewModel.mTopYAxisData.value.count {
            chartDataEntry.append(ChartDataEntry(x: airQualityInfoViewModel.mTimeStampData.value[i], y: datas[i]))
        }
        
        // Check if Value is less than or equal to Two
        if (airQualityInfoViewModel.mTopYAxisData.value.count <= 2) {
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
        
        self.topChartView.changeData(lineChartData: data)
        
        if (tab == TktConstants.Key.tabTempAndHum) {
            let unit = self.preferences.integer(forKey: TktConstants.Key.UnitPreference)
            
            let lLimit = self.tempLowerLimit ?? self.airQualityInfoViewModel.lowerLimit
            let uLimit = self.tempUpperLimit ?? self.airQualityInfoViewModel.upperLimit
            
            let min = [lLimit, datas.min()!.rounded()].min()!
            let max = [uLimit, datas.max()!.rounded()].max()!
            
            self.topChartView.setYAxisProperties(mActiveDataType: 0, minY: min, maxY: max, unit: unit)
            
        } else if (tab == TktConstants.Key.tabTempAndHum) {
            let unit = self.preferences.integer(forKey: TktConstants.Key.UnitPreference)
            
            let min = 0.0
            let max = (self.airQualityInfoViewModel.mTopYAxisData.value.max()! >  TktConstants.Default.VOC_THRESHOLD_MAX)
                ? self.airQualityInfoViewModel.mTopYAxisData.value.max()! : TktConstants.Default.VOC_THRESHOLD_MAX
            self.topChartView.setYAxisProperties(mActiveDataType: 0, minY: min, maxY: max, unit: unit)
        }
        
        if (chartSegmentedControl.selectedIndex == 1 || chartSegmentedControl.selectedIndex == 2) {
            // Zoom Chart for '1' == '7 Days' and '2' == 'Monthly' Tabs
            self.topChartView.zoomChart(numberOfDaysToZoom: 2)
        }
    }
    
    
    private func setBottomChartData(datas: [Double], tab: String) {
        var chartDataEntry: [ChartDataEntry] = [ChartDataEntry]()
        
        for i in 0 ..< airQualityInfoViewModel.mTopYAxisData.value.count {
            chartDataEntry.append(ChartDataEntry(x: airQualityInfoViewModel.mTimeStampData.value[i], y: datas[i]))
        }
        
        // Check if Value is less than or equal to Two
        if (airQualityInfoViewModel.mTopYAxisData.value.count <= 2) {
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
        
        self.bottomChartView.changeData(lineChartData: data)
        
        if (tab == TktConstants.Key.tabTempAndHum) {
            let unit = self.preferences.integer(forKey: TktConstants.Key.UnitPreference)
            self.bottomChartView.setYAxisProperties(mActiveDataType: 1, minY: 0.0, maxY: 100.0, unit: unit)
        
        } else if (tab == TktConstants.Key.tabTempAndHum) {
            let unit = self.preferences.integer(forKey: TktConstants.Key.UnitPreference)
            let min = 100.0
            let max = (self.airQualityInfoViewModel.mBottomYAxisData.value.max()! >  TktConstants.Default.CO2_THRESHOLD_MAX) ? self.airQualityInfoViewModel.mBottomYAxisData.value.max()! : TktConstants.Default.CO2_THRESHOLD_MAX
            self.topChartView.setYAxisProperties(mActiveDataType: 0, minY: min, maxY: max, unit: unit)
            
            self.bottomChartView.setYAxisProperties(mActiveDataType: 1, minY: 0.0, maxY: 100.0, unit: unit)
        }
        
        if (chartSegmentedControl.selectedIndex == 1 || chartSegmentedControl.selectedIndex == 2) {
            // Zoom Chart for '1' == '7 Days' and '2' == 'Monthly' Tabs
            self.bottomChartView.zoomChart(numberOfDaysToZoom: 2)
        }
    }
    
    private func setChartData(datas: [Double], chart: LineChartView) {
        // Clear LineChart previous data if there is any
        chart.data = nil
        chart.xAxis.valueFormatter = nil
        chart.resetZoom()
        //chart.fitScreen()
        
        var chartDataEntry: [ChartDataEntry] = [ChartDataEntry]()
        
        for i in 0 ..< datas.count {
            chartDataEntry.append(ChartDataEntry(x: airQualityInfoViewModel.mTimeStampData.value[i], y: datas[i]))
        }
        
        // Check if Value is less than or equal to Two
        if (datas.count <= 2) {
            chartDataEntry = addFirstDataPoint(dataEntry: chartDataEntry)
        }
        
        let dataLineGraph: LineChartDataSet = LineChartDataSet(values: chartDataEntry, label: "")
        dataLineGraph.axisDependency = .left
        dataLineGraph.setColor(UIColor(red: 128, green: 129, blue: 132))
        dataLineGraph.lineWidth = 1.5
        dataLineGraph.fillAlpha = 65 / 255.0
        dataLineGraph.fillColor = UIColor(red: 77, green: 196, blue: 193)
        dataLineGraph.highlightColor = UIColor.clear
        dataLineGraph.drawCirclesEnabled = false
        dataLineGraph.drawFilledEnabled = true
        dataLineGraph.fillFormatter = self.dataSetFillFormatter
        
        var dataSets: [LineChartDataSet] = [LineChartDataSet]()
        dataSets.append(dataLineGraph)
        
        let data: LineChartData = LineChartData(dataSets: dataSets)
        data.setDrawValues(false)
        data.setValueTextColor(UIColor(red: 128, green: 129, blue: 132))
        
        chart.data = data
        chart.xAxis.valueFormatter = self.xAxisValueFormatter
        chart.xAxis.granularity = 1.0 // Set granularity always to reset xAxis Scale
        
        if (chartSegmentedControl.selectedIndex == 1 || chartSegmentedControl.selectedIndex == 2) {
            // Zoom Chart for '1' == '7 Days' and '2' == 'Monthly' Tabs
            zoomToTwoDays(xMax: chart.highestVisibleX, xMin: chart.lowestVisibleX, chart: chart)
        }
        
        if (data.entryCount < 30) {
            chart.animate(xAxisDuration: 0.5)
        } else {
            chart.animate(xAxisDuration: 1.0, easingOption: .linear)
        }
    }
    
        // MARK: EXP - DataTypeSegementChanged
    
    func dataTypeSegmentedValueChanged(_ sender: AnyObject?) {
        
        switch dataTypeSegmentedControl.selectedIndex {
        case 0:
            showActivityIncidator()
            freezeControls()
            airQualityInfoViewModel.attrToFetch = TktConstants.Key.tabTempAndHum
            
            // Generate Today's Temperature Data in Chart
            var from = NSNumber(value: (currentDate?.startOfDay.timeIntervalSince1970)!)
            var to = NSNumber(value: (currentDate?.endOfDay.timeIntervalSince1970)!)
            
            if (chartSegmentedControl.selectedIndex == 1) { // Weekly Tab
                from = NSNumber(value: (lastWeekDate?.startOfDay.timeIntervalSince1970)!)
                to = NSNumber(value: (now?.endOfDay.timeIntervalSince1970)!)
            } else if (chartSegmentedControl.selectedIndex == 2) { // Monthly Tab
                //let currentYear = calendar.component(.year, from: now!)
                let components = DateComponents(year: selectedYear!, month: selectedMonth! + 1)
                if let startOfMonth = calendar.date(from: components) {
                    
                    var lastDayComponent = DateComponents()
                    lastDayComponent.month = 1
                    lastDayComponent.day = -1
                    let endOfMonth = calendar.date(byAdding: lastDayComponent, to: startOfMonth)
                    
                    from = NSNumber(value: startOfMonth.timeIntervalSince1970)
                    to = NSNumber(value: (endOfMonth?.timeIntervalSince1970)!)
                }
            }
            
            airQualityInfoViewModel.generateChartData(from: from, to: to)
            
        case 1:
            showActivityIncidator()
            freezeControls()
            airQualityInfoViewModel.attrToFetch = Globals.isAirComfort() ? TktConstants.Key.tabCo2AndVoc : TktConstants.Key.tabDecibelAndLux
            
            // Generate Today's Humidity Data in Chart
            var from = NSNumber(value: (currentDate?.startOfDay.timeIntervalSince1970)!)
            var to = NSNumber(value: (currentDate?.endOfDay.timeIntervalSince1970)!)
            
            if (chartSegmentedControl.selectedIndex == 1) { // Weekly tab
                from = NSNumber(value: (lastWeekDate?.startOfDay.timeIntervalSince1970)!)
                to = NSNumber(value: (now?.endOfDay.timeIntervalSince1970)!)
            } else if (chartSegmentedControl.selectedIndex == 2) { // Monthly Tab
                //let currentYear = calendar.component(.year, from: now!)
                let components = DateComponents(year: selectedYear!, month: selectedMonth! + 1)
                if let startOfMonth = calendar.date(from: components) {
                    
                    var lastDayComponent = DateComponents()
                    lastDayComponent.month = 1
                    lastDayComponent.day = -1
                    let endOfMonth = calendar.date(byAdding: lastDayComponent, to: startOfMonth)
                    
                    from = NSNumber(value: startOfMonth.timeIntervalSince1970)
                    to = NSNumber(value: (endOfMonth?.timeIntervalSince1970)!)
                }
            }
            
            airQualityInfoViewModel.generateChartData(from: from, to: to)
            
        default:
            return
        }
    }
    
