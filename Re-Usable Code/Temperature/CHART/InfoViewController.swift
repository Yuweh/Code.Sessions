    //TktConstants
        static let MinTHI = "-minTHI"
        static let MaxTHI = "-maxTHI"
        static let DefaultMinimumTHI: Double = 16.0
        static let DefaultMaximumTHI: Double = 96.0

    //InfoVC

//Properties
    @IBOutlet weak var mChartTHI: ChartHelper!


    var thiLowerLimit: Double?
    var thiUpperLimit: Double?


//ViewDidLoad
    self.mChartTHI.initializeChart()
    self.mChartTHI.setTitle(title: "\("THI".localized)(\(TktConstants.Units.THI))")
    self.mChartTHI.delegate = self
    self.mChartTHI.doubleTapToZoomEnabled = false

    @address
    assignHumidityLimitLines(address: address)

    @observable
    self.setTHIChartData(datas: self.airComfortInfoViewModel.mTHIYAxisData.value)
    self.mChartTHI.setLimits(min: self.thiLowerLimit!, max: self.thiUpperLimit!)


//Functions

//Set THIChart

    private func setTHIChartData(datas: [Double]) {
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
        
        let unit = self.preferences.integer(forKey: TktConstants.Key.UnitPreference)

        self.mChartTHI.changeData(lineChartData: data)
        self.mChartTHI.setYAxisProperties(mActiveDataType: 1, minY: 70.0, maxY: 90.0, unit: unit)
        
        if (chartSegmentedControl.selectedIndex == 1 || chartSegmentedControl.selectedIndex == 2) {
            // Zoom Chart for '1' == '7 Days' and '2' == 'Monthly' Tabs
            self.mChartTHI.zoomChart(numberOfDaysToZoom: 2)
        }
    }


//SetLimitLines

        private func assignTHILimitLines(address: String) {
        let minTHIKey = "\(address)\(TktConstants.Key.MinTHI)"
        let maxTHIKey = "\(address)\(TktConstants.Key.MaxTHI)"
        
        if preferences.object(forKey: minTHIKey) != nil {
            let value = preferences.double(forKey: minTHIKey)
            thiLowerLimit = value
        } else {
            thiLowerLimit = TktConstants.Default.DefaultMinimumTHI
        }
        
        if preferences.object(forKey: maxTHIKey) != nil {
            let value = preferences.double(forKey: maxTHIKey)
            thiLowerLimit = value
        } else {
            thiUpperLimit = TktConstants.Default.DefaultMaximumTHI
        }
    }
