

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
        
        if (tab == TktConstants.Key.attrTempHum) {
            let unit = self.preferences.integer(forKey: TktConstants.Key.UnitPreference)
            
            let lLimit = self.tempLowerLimit ?? self.airQualityInfoViewModel.lowerLimit
            let uLimit = self.tempUpperLimit ?? self.airQualityInfoViewModel.upperLimit
            
            let min = [lLimit, datas.min()!.rounded()].min()!
            let max = [uLimit, datas.max()!.rounded()].max()!
            
            self.topChartView.setYAxisProperties(mActiveDataType: 0, minY: min, maxY: max, unit: unit)
            
        } else if (tab == TktConstants.Key.attrTempHum) {
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
        
        if (tab == TktConstants.Key.attrTempHum) {
            let unit = self.preferences.integer(forKey: TktConstants.Key.UnitPreference)
            self.bottomChartView.setYAxisProperties(mActiveDataType: 1, minY: 0.0, maxY: 100.0, unit: unit)
            
        } else if (tab == TktConstants.Key.attrTempHum) {
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
    
    private func setTHIChartData(datas: [Double]) {
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
        
        let unit = self.preferences.integer(forKey: TktConstants.Key.UnitPreference)
        
        self.mChartTHI.changeData(lineChartData: data)
        self.mChartTHI.setYAxisProperties(mActiveDataType: 4, minY: 70.0, maxY: 90.0, unit: unit)
        
        if (chartSegmentedControl.selectedIndex == 1 || chartSegmentedControl.selectedIndex == 2) {
            // Zoom Chart for '1' == '7 Days' and '2' == 'Monthly' Tabs
            self.mChartTHI.zoomChart(numberOfDaysToZoom: 2)
        }
    }
