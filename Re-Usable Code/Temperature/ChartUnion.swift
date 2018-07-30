
    var xAxisValueFormatter: IAxisValueFormatter?

                self.setChartData(datas: self.airComfortInfoViewModel.mTopYAxisData.value, chart: self.mChartTop)
                self.setChartData(datas: self.airComfortInfoViewModel.mBottomYAxisData.value, chart: self.mChartBottom)
                self.setChartData(datas: self.airComfortInfoViewModel.mTHIYAxisData.value, chart: self.mChartTHI)


        private func setChartData(datas: [Double], chart: ChartHelper) {
        var chartDataEntry: [ChartDataEntry] = [ChartDataEntry]()
        
        for i in 0 ..< airComfortInfoViewModel.mTHIYAxisData.value.count {
            chartDataEntry.append(ChartDataEntry(x: airComfortInfoViewModel.mTimeStampData.value[i], y: datas[i]))
        }
        
        // Check if Value is less than or equal to Two
        if (airComfortInfoViewModel.mTHIYAxisData.value.count <= 2) {
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
        
        switch chart {
        case mChartTop:
            let lLimit = self.tempLowerLimit ?? self.airComfortInfoViewModel.lowerLimit
            let uLimit = self.tempUpperLimit ?? self.airComfortInfoViewModel.upperLimit
            
            let min = [lLimit, datas.min()!.rounded()].min()!
            let max = [uLimit, datas.max()!.rounded()].max()!
            
            chart.changeData(lineChartData: data)
            chart.setYAxisProperties(mActiveDataType: 0, minY: min, maxY: max, unit: unit)
            
        case mChartBottom:
            chart.changeData(lineChartData: data)
            chart.setYAxisProperties(mActiveDataType: 1, minY: 0.0, maxY: 100.0, unit: unit)
            
        case mChartTHI:
            chart.changeData(lineChartData: data)
            chart.setYAxisProperties(mActiveDataType: 4, minY: 70.0, maxY: 90.0, unit: unit)
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
