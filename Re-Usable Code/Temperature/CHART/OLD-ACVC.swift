//
//

import UIKit
import RxCocoa
import RxSwift
import Charts

class AirComfortInfoViewController: UIViewController, CoverflowViewControllerDelegate {
    
    let disposeBag = DisposeBag()
    
    // AirSensorOutlets
    @IBOutlet weak var airSensorDataContainer: UIView!
    @IBOutlet weak var batteryImage_as: UIImageView!
    @IBOutlet weak var batteryLabel_as: UILabel!
    @IBOutlet weak var sensorIcon_as: CustomButton!
    @IBOutlet weak var qualityLabel_as: UILabel!
    @IBOutlet weak var firmwareVersion_as: UILabel!
    
    @IBOutlet weak var sensorTemperature_as: UILabel!
    @IBOutlet weak var sensorHumidity_as: UILabel!
    @IBOutlet weak var sensorLux: UILabel!
    @IBOutlet weak var sensorDecibel: UILabel!
    
    // AirComfort Outlets
    @IBOutlet weak var sensorIconContainer: UIView!
    @IBOutlet weak var batteryImage: UIImageView!
    @IBOutlet weak var batteryLabel: UILabel!
    @IBOutlet weak var sensorIcon: UIButton!
    @IBOutlet weak var firmwareVersion: UILabel!
    
    @IBOutlet weak var dataContainer: UIView!
    @IBOutlet weak var sensorTemperature: UILabel!
    @IBOutlet weak var sensorHumidity: UILabel!
    @IBOutlet weak var temperatureIcon: UIImageView!
    @IBOutlet weak var humidityIcon: UIImageView!
    @IBOutlet weak var lastUpdatedTimestamp: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    
    @IBOutlet weak var previousButton: CustomButton!
    @IBOutlet weak var nextButton: CustomButton!
    @IBOutlet weak var weeklyLabel: UILabel!
    @IBOutlet weak var datePicker: CustomButton!
    @IBOutlet weak var monthPicker: CustomButton!
    @IBOutlet weak var yearPicker: CustomButton!
    
    @IBOutlet weak var chartSegmentedControl: CustomSegmentedControl!
    
    @IBOutlet weak var mChartTop: ChartHelper!
    @IBOutlet weak var mChartBottom: ChartHelper!    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var sensorData: sensorListCellData?
    var indexPath: IndexPath?
    let airComfortInfoViewModel = AirComfortInfoViewModel()
    
    var isRefreshButtonRotating = false
    var now: Date?
    var currentDate: Date?
    var lastWeekDate: Date?
    var selectedMonth: Int?
    var selectedYear: Int?
    
    var upperLimit: ChartLimitLine?
    var lowerLimit: ChartLimitLine?
    
    var tempLowerLimit: Double?
    var tempUpperLimit: Double?
    var humLowerLimit: Double?
    var humUpperLimit: Double?
    var decLowerLimit: Double?
    var decUpperLimit: Double?
    var luxLowerLimit: Double?
    var luxUpperLimit: Double?
    
    var temporarySensorListCellData: sensorListCellData?
    var temporaryUnit: Int?
    var temporaryOriginalUnit: Int?
    
    let calendar = Calendar.current
    
    let preferences = UserDefaults.standard
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        Globals.log("AirComfortInfoViewController init()")
        
        self.mChartTop.initializeChart()
        let topChartTitle = (preferences.integer(forKey: TktConstants.Key.UnitPreference) == 1) ? "\("temperature".localized)(\(TktConstants.Units.Fahrenheit))" : "\("temperature".localized)(\(TktConstants.Units.Celsius))"
        
        self.mChartTop.setTitle(title: topChartTitle)
        self.mChartBottom.initializeChart()
        self.mChartBottom.setTitle(title: "\("humidity".localized)(\(TktConstants.Units.Percent))")
        
        self.mChartTop.delegate = self
        self.mChartBottom.delegate = self
        
        self.mChartTop.doubleTapToZoomEnabled = false
        self.mChartBottom.doubleTapToZoomEnabled = false
        
        // Add NotificationCenter Observer for Sensor Connection Failed
        NotificationCenter.default.addObserver(self, selector: #selector(AirComfortInfoViewController.sensorConnectionFailed(_:)), name: NSNotification.Name(rawValue: TktConstants.Notification.ConnectionFailedNotification), object: nil)
        
        // Add NotificationCenter Observer for Update Data Peripherals
        NotificationCenter.default.addObserver(self, selector: #selector(AirComfortInfoViewController.updateSensorData(_:)), name: NSNotification.Name(rawValue: TktConstants.Notification.SensorDataUpdateNotification), object: nil)
        
        // Add NotificationCenter Observer for Update UI
        NotificationCenter.default.addObserver(self, selector: #selector(AirComfortInfoViewController.updateSensorData(_:)), name: NSNotification.Name(rawValue: TktConstants.Notification.SensorDataUpdateUINotification), object: nil)
        
        // Add NotificationCenter Observer for DatePicker
        NotificationCenter.default.addObserver(self, selector: #selector(AirComfortInfoViewController.newDatePicked(_:)), name: NSNotification.Name(rawValue: TktConstants.Notification.DatePickerNotification), object: nil)
        
        // Add NotificationCenter Observer for MonthPicker
        NotificationCenter.default.addObserver(self, selector: #selector(AirComfortInfoViewController.newMonthPicked(_:)), name: NSNotification.Name(rawValue: TktConstants.Notification.MonthPickerNotification), object: nil)
        
        // Add NotificationCenter Observer for YearPicker
        NotificationCenter.default.addObserver(self, selector: #selector(AirComfortInfoViewController.newYearPicked(_:)), name: NSNotification.Name(rawValue: TktConstants.Notification.YearPickerNotification), object: nil)
        
        // Add NotificationCenter Observer for DismissModal in MonthPicker and YearPicker
        NotificationCenter.default.addObserver(self, selector: #selector(AirComfortInfoViewController.fromDismissModal(_:)), name: NSNotification.Name(rawValue: TktConstants.Notification.DismissModalNotification), object: nil)
        
        // Add NotificationCenter Observer for downloadLogChartRefresh
        NotificationCenter.default.addObserver(self, selector: #selector(AirComfortInfoViewController.downloadLogsChartRefresh(_:)), name: NSNotification.Name(rawValue: TktConstants.Notification.DownloadLogsNotification), object: nil)
        
        // Add NotificationCenter Observer for immediateReadChartRefresh
        NotificationCenter.default.addObserver(self, selector: #selector(AirComfortInfoViewController.immediateReadChartRefresh(_:)), name: NSNotification.Name(rawValue: TktConstants.Notification.DoImmediateReadNotification), object: nil)
        
        // Add NotifcationCenter Observer for formatNavigationFromInfoNotification
        NotificationCenter.default.addObserver(self, selector: #selector(AirComfortInfoViewController.formatNavigationBar(_:)), name: NSNotification.Name(rawValue: TktConstants.Notification.FormatNavigationFromInfoNotification), object: nil)
        
        // Add NotificationCenter Observer for SensorDataChangedNotification
        NotificationCenter.default.addObserver(self, selector: #selector(AirComfortInfoViewController.sensorDataChanged(_:)), name: NSNotification.Name(rawValue: TktConstants.Notification.SensorDataChangedNotification), object: nil)
        
        // Add NotificationCenter Observer for TemperatureRangeChangedNotification
        NotificationCenter.default.addObserver(self, selector: #selector(AirComfortInfoViewController.TemperatureRangeChanged(_:)), name:  NSNotification.Name(rawValue: TktConstants.Notification.TemperatureRangeChangedNotification), object: nil)
        
        // Add NotificationCenter Observer for HumidityRangeChangedNotification
        NotificationCenter.default.addObserver(self, selector: #selector(AirComfortInfoViewController.HumidityRangeChanged(_:)), name: NSNotification.Name(rawValue: TktConstants.Notification.HumidityRangeChangedNotification), object: nil)
        
        self.navigationController?.colorNavigationBar()
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = true
        
        // Add Shadow Below Views
        Globals.addShadowBelowRow(view: previousButton)
        Globals.addShadowBelowRow(view: nextButton)
        Globals.addShadowBelowRow(view: datePicker)
        Globals.addShadowBelowRow(view: monthPicker)
        Globals.addShadowBelowRow(view: yearPicker)
        Globals.addShadowBelowRow(view: refreshButton)
        
        lastUpdatedTimestamp.font = UIFont(name: "Antenna-Light", size: 9)!
        
        if preferences.object(forKey: TktConstants.Key.ShowHideFirmwareVersion) != nil {
            let settings = preferences.integer(forKey: TktConstants.Key.ShowHideFirmwareVersion)
            if (settings == 1) {
                firmwareVersion.isHidden = false
            } else {
                firmwareVersion.isHidden = true
            }
        }
        
        if let data = sensorData, let ip = indexPath {
            airComfortInfoViewModel.assignDataSource(indexPath: ip,sensor: data)
            
            self.navigationController?.navigationBar.topItem?.title = data.sensorName
            
            let titleAttributes = Globals.isAirComfort() ? [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Antenna-Light", size: 17)!] :[NSForegroundColorAttributeName: TktConstants.Color.AirSensor.GrayTextColor]
            self.navigationController?.navigationBar.titleTextAttributes = titleAttributes

            chartSegmentedControl.titles = [NSLocalizedString("day", comment: ""), NSLocalizedString("seven_days", comment: ""), NSLocalizedString("monthly", comment: "")]
            chartSegmentedControl.font = UIFont(name: "Antenna-Light", size: 12)!
            loadAirComfortObservableViews()
            
            chartSegmentedControl.addTarget(self, action: #selector(AirComfortInfoViewController.chartSegmentedValueChanged(_:)), for: .valueChanged)
            
            _ = airComfortInfoViewModel.vTimeStamp.asObservable().subscribe { value in
                if let element = value.element {
                    if let timestamp = Double(element!) {
                        let date = Date(timeIntervalSince1970: timestamp)
                        self.lastUpdatedTimestamp.text = "\(date.timeAgoSinceNow)"
                    }
                }
                }
                .addDisposableTo(disposeBag)
            
        }
        
        // Animate Refresh Button if it's Currently donwloading
        if (airComfortInfoViewModel.isSensorCurrentlyDownloading()) {
            animateRefreshButton()
            
            // This is Download Process
            if let _ = airComfortInfoViewModel.coreBluetoothManager.peripheralLoggerCtrlCharacteristics[(sensorData?.sensorUUID)!] {
                airComfortInfoViewModel.refreshType = TktConstants.Notification.DownloadLogsNotification
            }
        }
        
        // Set Current Date to Today
        now = Date()
        currentDate = now
        
        lastWeekDate = calendar.date(byAdding: .day, value: -6, to: currentDate!)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        let lastWeekString = dateFormatter.string(from: lastWeekDate!)
        let nowString = dateFormatter.string(from: currentDate!)
        weeklyLabel.text = "\(lastWeekString) - \(nowString)\(NSLocalizedString("(today)", comment: ""))"
        
        selectedMonth = currentDate!.month - 1
        selectedYear = currentDate!.year
        monthPicker.setTitle(calendar.monthSymbols[selectedMonth!], for: .normal)
        yearPicker.setTitle("\(currentDate!.year)", for: .normal)
        
        // Generate Today's Data in
        let from = NSNumber(value: (currentDate?.startOfDay.timeIntervalSince1970)!)
        let to = NSNumber(value: (currentDate?.endOfDay.timeIntervalSince1970)!)
        airComfortInfoViewModel.generateData(from: from, to: to)
        
        if let address = airComfortInfoViewModel.sensorData.value?.sensorMacAddress {
            assignTemperatureLimitLines(address: address)
            assignHumidityLimitLines(address: address)
        }

        _ = airComfortInfoViewModel.viewVariable.asObservable().subscribe { value in
            self.freezeControls()
            
            if (self.isDataNotEmpty()) {
                self.mChartTop.setLimits(min: self.tempLowerLimit!, max: self.tempUpperLimit!)
                self.setTopChartData(datas: self.airComfortInfoViewModel.mTopYAxisData.value)
                self.mChartBottom.setLimits(min: self.humLowerLimit!, max: self.humUpperLimit!)
                self.setBottomChartData(datas: self.airComfortInfoViewModel.mBottomYAxisData.value)
            } else {
                self.clearChartData()
            }
            
            if (!self.activityIndicator.isHidden) {
                self.activityIndicator.isHidden = true
            }
            
            if (self.mChartTop.isHidden && self.mChartBottom.isHidden) {
                self.mChartTop.isHidden = false
                self.mChartBottom.isHidden = false
            }
            }
            .addDisposableTo(disposeBag)
    }
    
    private func isDataNotEmpty() -> Bool {
        return self.airComfortInfoViewModel.mTimeStampData.value.count > 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isUserInteractionEnabled = true
        
        // Refresh Last Sync Timestamp
        airComfortInfoViewModel.refreshLastSyncTimeStamp()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        airComfortInfoViewModel.stopTimer()
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.backgroundColor = nil
        self.navigationController?.transparentNavigationBar()
        self.navigationController?.navigationBar.isUserInteractionEnabled = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == TktConstants.Segues.CoverFlowSegue {
            if let type = sensorData?.sensorType {
                let viewController = segue.destination as! CoverflowViewController
                viewController.sensorType = type
                viewController.delegate = self
            }
        } else if segue.identifier == TktConstants.Segues.DatePickerSegue {
            freezeControls()
            let viewController = segue.destination as! DatePickerViewController
            viewController.currentDate = self.currentDate
        } else if (segue.identifier == TktConstants.Segues.MonthPickerSegue) {
            freezeControls()
            let viewController = segue.destination as! MonthPickerViewController
            viewController.selectedIndex = selectedMonth
        } else if (segue.identifier == TktConstants.Segues.YearPickerSegue) {
            freezeControls()
            let viewController = segue.destination as! YearPickerViewController
            viewController.selectedIndex = selectedYear
        } else if (segue.identifier == TktConstants.Segues.InfoViewSegue) {
            let navigationController = segue.destination as! UINavigationController
            let infoViewController = navigationController.topViewController as! InfoViewController
            infoViewController.sensorData = airComfortInfoViewModel.sensorData.value
            
            if let tll = tempLowerLimit, let tul = tempUpperLimit, let hll = humLowerLimit, let hup = humUpperLimit {
                if preferences.object(forKey: TktConstants.Key.UnitPreference) != nil {
                    let unit = preferences.integer(forKey: TktConstants.Key.UnitPreference)
                    
                    if (unit == 1) {
                        infoViewController.selectedMinTempStr = "\(Int(tll))\(TktConstants.Units.Fahrenheit)"
                        infoViewController.selectedMaxTempStr = "\(Int(tul))\(TktConstants.Units.Fahrenheit)"
                        infoViewController.selectedMinHumStr = "\(Int(hll))\(TktConstants.Units.Percent)"
                        infoViewController.selectedMaxHumStr = "\(Int(hup))\(TktConstants.Units.Percent)"
                    } else {
                        infoViewController.selectedMinTempStr = "\(Int(tll))\(TktConstants.Units.Celsius)"
                        infoViewController.selectedMaxTempStr = "\(Int(tul))\(TktConstants.Units.Celsius)"
                        infoViewController.selectedMinHumStr = "\(Int(hll))\(TktConstants.Units.Percent)"
                        infoViewController.selectedMaxHumStr = "\(Int(hup))\(TktConstants.Units.Percent)"
                    }
                } else {
                    infoViewController.selectedMinTempStr = "\(Int(tll))\(TktConstants.Units.Celsius)"
                    infoViewController.selectedMaxTempStr = "\(Int(tul))\(TktConstants.Units.Celsius)"
                    infoViewController.selectedMinHumStr = "\(Int(hll))\(TktConstants.Units.Percent)"
                    infoViewController.selectedMaxHumStr = "\(Int(hup))\(TktConstants.Units.Percent)"
                }
                
                if(!Globals.isAirComfort()) {
                    if let dll = decLowerLimit, let dup = decUpperLimit, let lll = luxLowerLimit, let lul = luxUpperLimit {
                        infoViewController.selectedMinDecStr = "\(Int(dll))\(TktConstants.Units.Decibel)"
                        infoViewController.selectedMaxDecStr = "\(Int(dup))\(TktConstants.Units.Decibel)"
                        infoViewController.selectedMinLuxStr = "\(Int(lll))\(TktConstants.Units.Illuminance)"
                        infoViewController.selectedMaxLuxStr = "\(Int(lul))\(TktConstants.Units.Illuminance)"
                    }
                }
            }
        }
    }
    
    // MARK: Private Methods
    private func loadAirComfortObservableViews() {
        _ = airComfortInfoViewModel.vBatteryImage.asObservable().subscribe { value in
            if let element = value.element {
                self.batteryImage.image = element
            }
            }
            .addDisposableTo(disposeBag)
        
        _ = airComfortInfoViewModel.vBatteryLabel.asObservable().subscribe { value in
            if let element = value.element {
                self.batteryLabel.text = element
            }
            }
            .addDisposableTo(disposeBag)
        
        _ = airComfortInfoViewModel.vSensorIcon.asObservable().subscribe { value in
            if let element = value.element {
                DispatchQueue.global(qos: .userInteractive).sync {
                    self.sensorIcon.setImage(element, for: .normal)
                    self.sensorIcon.imageView?.contentMode = .scaleAspectFill
                }
            }
            }
            .addDisposableTo(disposeBag)
        
        _ = airComfortInfoViewModel.vFirmwareVersion.asObservable().subscribe { value in
            if let element = value.element {
                self.firmwareVersion.text = element
            }
            }
            .addDisposableTo(disposeBag)
        
        _ = airComfortInfoViewModel.vSensorTemperature.asObservable().subscribe { value in
            if let temperature = value.element ?? nil, let address = self.airComfortInfoViewModel.sensorData.value?.sensorMacAddress {
                self.temperatureIcon.image = Globals.getIconImage(view: TktConstants.CallingView.AirComfortInfoViewController, preferences: self.preferences, value: temperature, dataType: TktConstants.Key.attrTemperature, address: address)
                self.sensorTemperature.textColor = Globals.getTemperatureTextColor(view: TktConstants.CallingView.AirComfortInfoViewController, preferences: self.preferences, temperature: temperature, address: address)
                self.sensorTemperature.text = Globals.getDataText(preferences: self.preferences, data: temperature, isTemperature: true)
            }
            }
            .addDisposableTo(disposeBag)
        
        _ = airComfortInfoViewModel.vSensorHumidity.asObservable().subscribe { value in
            if let humidity = value.element ?? nil, let address = self.airComfortInfoViewModel.sensorData.value?.sensorMacAddress {
                self.humidityIcon.image = Globals.getIconImage(view: TktConstants.CallingView.AirComfortInfoViewController, preferences: self.preferences, value: humidity, dataType: TktConstants.Key.attrHumidity, address: address)
                self.sensorHumidity.textColor = Globals.getHumidityTextColor(view: TktConstants.CallingView.AirComfortInfoViewController, preferences: self.preferences, humidity: humidity, address: address)
                self.sensorHumidity.text = Globals.getDataText(preferences: self.preferences, data: humidity, isTemperature: false)
            }
            }
            .addDisposableTo(disposeBag)
    }
    
    private func showAlertforSettings(_ message: String) {
        let action = [
            UIAlertAction(title: NSLocalizedString("settings", comment: ""), style: .default) { (action) in
                if let url = URL(string: "App-Prefs:root=Bluetooth") {
                    UIApplication.shared.openURL(url)
                }
            },
            UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .cancel, handler: nil)
        ]
        
        Globals.showAlert(self, title: NSLocalizedString("", comment: ""), message: message, animated: true, completion: nil, actions: action)
    }
    
    private func clearChartData() {
        self.mChartTop.clearData(isFetchEmpty: self.airComfortInfoViewModel.isFetchEmpty)
        self.mChartBottom.clearData(isFetchEmpty: self.airComfortInfoViewModel.isFetchEmpty)
    }
    
    private func setTopChartData(datas: [Double]) {
        var chartDataEntry: [ChartDataEntry] = [ChartDataEntry]()
        
        for i in 0 ..< airComfortInfoViewModel.mTopYAxisData.value.count {
            chartDataEntry.append(ChartDataEntry(x: airComfortInfoViewModel.mTimeStampData.value[i], y: datas[i]))
        }
        
        // Check if Value is less than or equal to Two
        if (airComfortInfoViewModel.mTopYAxisData.value.count <= 2) {
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
        
        self.mChartTop.changeData(lineChartData: data)
        
        let unit = self.preferences.integer(forKey: TktConstants.Key.UnitPreference)
        
        let lLimit = self.tempLowerLimit ?? self.airComfortInfoViewModel.lowerLimit
        let uLimit = self.tempUpperLimit ?? self.airComfortInfoViewModel.upperLimit
        
        let min = [lLimit, datas.min()!.rounded()].min()!
        let max = [uLimit, datas.max()!.rounded()].max()!
        
        self.mChartTop.setYAxisProperties(mActiveDataType: 0, minY: min, maxY: max, unit: unit)
        
        if (chartSegmentedControl.selectedIndex == 1 || chartSegmentedControl.selectedIndex == 2) {
            // Zoom Chart for '1' == '7 Days' and '2' == 'Monthly' Tabs
            self.mChartTop.zoomChart(numberOfDaysToZoom: 2)
        }
    }
    
    private func setBottomChartData(datas: [Double]) {
        var chartDataEntry: [ChartDataEntry] = [ChartDataEntry]()
        
        for i in 0 ..< airComfortInfoViewModel.mTopYAxisData.value.count {
            chartDataEntry.append(ChartDataEntry(x: airComfortInfoViewModel.mTimeStampData.value[i], y: datas[i]))
        }
        
        // Check if Value is less than or equal to Two
        if (airComfortInfoViewModel.mTopYAxisData.value.count <= 2) {
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
        
        self.mChartBottom.changeData(lineChartData: data)
        self.mChartBottom.setYAxisProperties(mActiveDataType: 1, minY: 0.0, maxY: 100.0, unit: unit)
        
        if (chartSegmentedControl.selectedIndex == 1 || chartSegmentedControl.selectedIndex == 2) {
            // Zoom Chart for '1' == '7 Days' and '2' == 'Monthly' Tabs
            self.mChartBottom.zoomChart(numberOfDaysToZoom: 2)
        }
    }
    
    private func addFirstDataPoint(dataEntry: [ChartDataEntry]) -> [ChartDataEntry] {
        // Add Temporary Data
        let counter: Int = (dataEntry.count == 2) ? 1 : 2
        var entry: [ChartDataEntry] = [ChartDataEntry]()
        
        for i in 1 ... counter {
            if let x = dataEntry.first?.x, let y = dataEntry.first?.y {
                let minusMinutes = Double(i) * TktConstants.Time.MINUTES_PERIOD_5
                entry.append(ChartDataEntry(x: (x - minusMinutes), y: y))
            }
        }
        // Append the saved Data from Sensor
        entry.append(contentsOf: dataEntry)
        
        return entry
    }
    
    private func assignTemperatureLimitLines(address: String) {
        let minTemperatureKey = "\(address)\(TktConstants.Key.MinTemperature)"
        let maxTemperatureKey = "\(address)\(TktConstants.Key.MaxTemperature)"
        
        // --------------------------------------------------------------------
        // Minimum Temperature Limitline Ex: "88:88:88:88:88:88-minTemperature"
        if preferences.object(forKey: minTemperatureKey) != nil {
            let value = preferences.double(forKey: minTemperatureKey)
            
            if preferences.object(forKey: TktConstants.Key.UnitPreference) != nil {
                let unit = preferences.integer(forKey: TktConstants.Key.UnitPreference)
                if (unit == 1) {
                    let celsius = Float(value)
                    let fahrenheit = Globals.temperature2Fahrenheit(celsius: celsius)
                    
                    tempLowerLimit = Double(fahrenheit).rounded()
                } else {
                    tempLowerLimit = value
                }
            } else {
                tempLowerLimit = value
            }
        } else {
            if preferences.object(forKey: TktConstants.Key.UnitPreference) != nil {
                let unit = preferences.integer(forKey: TktConstants.Key.UnitPreference)
                if (unit == 1) {
                    tempLowerLimit = TktConstants.Default.DefaultMinimumFahrenheitTemperature
                } else {
                    tempLowerLimit = TktConstants.Default.DefaultMinimumCelsiusTemperature
                }
            } else {
                tempLowerLimit = TktConstants.Default.DefaultMinimumCelsiusTemperature
            }
        }
        
        // --------------------------------------------------------------------
        // Maximum Temperature Limitline Ex: "88:88:88:88:88:88-minTemperature"
        if preferences.object(forKey: maxTemperatureKey) != nil {
            let value = preferences.double(forKey: maxTemperatureKey)
            
            if preferences.object(forKey: TktConstants.Key.UnitPreference) != nil {
                let unit = preferences.integer(forKey: TktConstants.Key.UnitPreference)
                if (unit == 1) {
                    let celsius = Float(value)
                    let fahrenheit = Globals.temperature2Fahrenheit(celsius: celsius)
                    
                    tempUpperLimit = Double(fahrenheit).rounded()
                } else {
                    tempUpperLimit = value
                }
            } else {
                tempUpperLimit = value
            }
        } else {
            if preferences.object(forKey: TktConstants.Key.UnitPreference) != nil {
                let unit = preferences.integer(forKey: TktConstants.Key.UnitPreference)
                if (unit == 1) {
                    tempUpperLimit = TktConstants.Default.DefaultMaximumFahrenheitTemperature
                } else {
                    tempUpperLimit = TktConstants.Default.DefaultMaximumCelsiusTemperature
                }
            } else {
                tempUpperLimit = TktConstants.Default.DefaultMaximumCelsiusTemperature
            }
        }
    }
    
    private func assignHumidityLimitLines(address: String) {
        let minHumidityKey = "\(address)\(TktConstants.Key.MinHumidity)"
        let maxHumidityKey = "\(address)\(TktConstants.Key.MaxHumidity)"
        
        // --------------------------------------------------------------------
        // Minimum Humidity Limitline Ex: "88:88:88:88:88:88-minHumidity"
        if preferences.object(forKey: minHumidityKey) != nil {
            let value = preferences.double(forKey: minHumidityKey)
            humLowerLimit = value
        } else {
            humLowerLimit = TktConstants.Default.DefaultMinimumHumidity
        }
        
        // --------------------------------------------------------------------
        // Max Humidity Limitline Ex: "88:88:88:88:88:88-maxHumidity"
        if preferences.object(forKey: maxHumidityKey) != nil {
            let value = preferences.double(forKey: maxHumidityKey)
            humUpperLimit = value
        } else {
            humUpperLimit = TktConstants.Default.DefaultMaximumHumidity
        }
    }
    
    private func showActivityIncidator() {
        mChartTop.isHidden = true
        mChartBottom.isHidden = true
        activityIndicator.isHidden = false
    }
    
    private func freezeControls() {
        chartSegmentedControl.isUserInteractionEnabled = !chartSegmentedControl.isUserInteractionEnabled
        previousButton.isUserInteractionEnabled = !previousButton.isUserInteractionEnabled
        nextButton.isUserInteractionEnabled = !nextButton.isUserInteractionEnabled
        datePicker.isUserInteractionEnabled = !datePicker.isUserInteractionEnabled
        monthPicker.isUserInteractionEnabled = !monthPicker.isUserInteractionEnabled
        yearPicker.isUserInteractionEnabled = !yearPicker.isUserInteractionEnabled
    }
    
    // MARK: Notification Methods
    @objc private func updateSensorData(_ notification: Notification) {
        DispatchQueue.main.async {
            guard let data = notification.object as? sensorListCellData else {
                Globals.log("Updated Data is Invalid")
                
                return
            }
            
            if (data.sensorUUID == self.airComfortInfoViewModel.sensorData.value?.sensorUUID) {
                
                let isUpdatingSensorUI = self.airComfortInfoViewModel.isUpdatingSensorUI()
                
                if (isUpdatingSensorUI) {
                    if (self.isRefreshButtonRotating) {
                        self.refreshButton.layer.removeAllAnimations()
                        self.refreshButton.isEnabled = true
                        self.refreshButton.layer.shadowOpacity = 0.10
                        self.isRefreshButtonRotating = false
                    }
                    
                    if let _ = self.temporarySensorListCellData {
                        // Remove Temporary SensorListCellData
                        self.temporarySensorListCellData = nil
                        self.temporaryUnit = nil
                        self.temporaryOriginalUnit = nil
                    }
                    
                    if let ip = self.indexPath {
                        self.navigationController?.navigationBar.topItem?.title = data.sensorName
                        self.airComfortInfoViewModel.assignDataSource(indexPath: ip, sensor: data)
                    }
                }
                
            }
        }
    }
    
    @objc private func sensorConnectionFailed(_ notification: Notification) {
        DispatchQueue.main.async {
            if (self.isRefreshButtonRotating) {
                self.refreshButton.layer.removeAllAnimations()
                self.refreshButton.isEnabled = true
                self.isRefreshButtonRotating = false
            }
        }
    }
    
    @objc private func newDatePicked(_ notification: Notification) {
        guard let date = notification.object as? Date else {
            Globals.log("Invalid Date From UIDatePicker")
            
            return
        }
        
        showActivityIncidator()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let date1 = dateFormatter.string(from: now!)
        let date2 = dateFormatter.string(from: date)
        
        // Set Current Date to Selected Date
        currentDate = date
        
        if (date1 == date2) {
            datePicker.setTitle(NSLocalizedString("today", comment: ""), for: .normal)
            nextButton.isEnabled = false
        } else {
            dateFormatter.dateFormat = "MMM dd"
            let dateString = dateFormatter.string(from: currentDate!)
            datePicker.setTitle(dateString, for: .normal)
            nextButton.isEnabled = true
        }
        
        let from = NSNumber(value: (currentDate?.startOfDay.timeIntervalSince1970)!)
        let to = NSNumber(value: (currentDate?.endOfDay.timeIntervalSince1970)!)
        airComfortInfoViewModel.generateData(from: from, to: to)
    }
    
    @objc private func newMonthPicked(_ notification: Notification) {
        guard let index = notification.object as? Int else {
            Globals.log("Invalid index from MonthPicker")
            
            return
        }
        
        showActivityIncidator()
        
        selectedMonth = index
        monthPicker.setTitle(calendar.monthSymbols[selectedMonth!], for: .normal)
        
        // Generate Monthly Data in Chart
        let components = DateComponents(year: selectedYear!, month: selectedMonth! + 1)
        if let startOfMonth = calendar.date(from: components) {
            
            var lastDayComponent = DateComponents()
            lastDayComponent.month = 1
            lastDayComponent.day = -1
            let endOfMonth = calendar.date(byAdding: lastDayComponent, to: startOfMonth)
            
            let from = NSNumber(value: startOfMonth.timeIntervalSince1970)
            let to = NSNumber(value: (endOfMonth?.timeIntervalSince1970)!)
            airComfortInfoViewModel.generateData(from: from, to: to)
        }
        
    }
    
    @objc private func newYearPicked(_ notification: Notification) {
        guard let year = notification.object as? Int else {
            Globals.log("Invalid Year from YearPicker")
            
            return
        }
        
        showActivityIncidator()
        
        selectedYear = year
        yearPicker.setTitle("\(selectedYear!)", for: .normal)
        
        let components = DateComponents(year: selectedYear!, month: selectedMonth! + 1)
        if let startOfMonth = calendar.date(from: components) {
            
            var lastDayComponent = DateComponents()
            lastDayComponent.month = 1
            lastDayComponent.day = -1
            let endOfMonth = calendar.date(byAdding: lastDayComponent, to: startOfMonth)
            
            let from = NSNumber(value: startOfMonth.timeIntervalSince1970)
            let to = NSNumber(value: (endOfMonth?.timeIntervalSince1970)!)
            airComfortInfoViewModel.generateData(from: from, to: to)
        }
    }
    
    @objc private func fromDismissModal(_ notification: Notification) {
        freezeControls()
    }
    
    @objc private func downloadLogsChartRefresh(_ notification: Notification) {
        
        if (airComfortInfoViewModel.refreshType == TktConstants.Notification.DownloadLogsNotification) {
            showActivityIncidator()
            freezeControls()
            
            var from: NSNumber?
            var to: NSNumber?
            
            switch chartSegmentedControl.selectedIndex {
            case 0:
                from = NSNumber(value: (currentDate?.startOfDay.timeIntervalSince1970)!)
                to = NSNumber(value: (now?.endOfDay.timeIntervalSince1970)!)
            case 1:
                from = NSNumber(value: (lastWeekDate?.startOfDay.timeIntervalSince1970)!)
                to = NSNumber(value: (now?.endOfDay.timeIntervalSince1970)!)
            case 2:
                // Generate Monthly Data in Chart
                let components = DateComponents(year: selectedYear!, month: selectedMonth! + 1)
                if let startOfMonth = calendar.date(from: components) {
                    
                    var lastDayComponent = DateComponents()
                    lastDayComponent.month = 1
                    lastDayComponent.day = -1
                    let endOfMonth = calendar.date(byAdding: lastDayComponent, to: startOfMonth)
                    
                    from = NSNumber(value: startOfMonth.timeIntervalSince1970)
                    to = NSNumber(value: (endOfMonth?.timeIntervalSince1970)!)
                }
            default:
                return
            }
            
            airComfortInfoViewModel.generateData(from: from!, to: to!)
        }
    }
    
    @objc private func immediateReadChartRefresh(_ notification: Notification) {
        
        if (airComfortInfoViewModel.refreshType == TktConstants.Notification.DoImmediateReadNotification) {
            showActivityIncidator()
            freezeControls()
            
            var from: NSNumber?
            var to: NSNumber?
            
            switch chartSegmentedControl.selectedIndex {
            case 0:
                from = NSNumber(value: (currentDate?.startOfDay.timeIntervalSince1970)!)
                to = NSNumber(value: (now?.endOfDay.timeIntervalSince1970)!)
            case 1:
                from = NSNumber(value: (lastWeekDate?.startOfDay.timeIntervalSince1970)!)
                to = NSNumber(value: (now?.endOfDay.timeIntervalSince1970)!)
            case 2:
                // Generate Monthly Data in Chart
                let components = DateComponents(year: selectedYear!, month: selectedMonth! + 1)
                if let startOfMonth = calendar.date(from: components) {
                    
                    var lastDayComponent = DateComponents()
                    lastDayComponent.month = 1
                    lastDayComponent.day = -1
                    let endOfMonth = calendar.date(byAdding: lastDayComponent, to: startOfMonth)
                    
                    from = NSNumber(value: startOfMonth.timeIntervalSince1970)
                    to = NSNumber(value: (endOfMonth?.timeIntervalSince1970)!)
                }
            default:
                return
            }
            
            airComfortInfoViewModel.generateData(from: from!, to: to!)
        }
    }
    
    @objc private func formatNavigationBar(_ notification: Notification) {
        self.navigationController?.colorNavigationBar()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @objc private func sensorDataChanged(_ notification: Notification) {
        guard let icon = notification.userInfo?["icon"] as? UIImage,
            let name = notification.userInfo?["name"] as? String,
            let period = notification.userInfo?["period"] as? String else {
            Globals.log("Sensor Data Invalid")
            
            return
        }
        
        if let oldData = airComfortInfoViewModel.sensorData.value {
            let data = sensorListCellData(
                sensorID: oldData.sensorID,
                sensorIcon: icon,
                sensorName: name,
                sensorType: oldData.sensorType,
                sensorTemperature: oldData.sensorTemperature,
                sensorHumidity: oldData.sensorHumidity,
                sensorVOC: oldData.sensorVOC,
                sensorCO2: oldData.sensorCO2,
                sensorDecibel: oldData.sensorDecibel,
                sensorLux: oldData.sensorLux,
                sensorBatteryLevel: oldData.sensorBatteryLevel,
                sensorPeriod: period,
                sensorResetTimeStamp: oldData.sensorResetTimeStamp,
                sensorFirmwareVersion: oldData.sensorFirmwareVersion,
                sensorDateCreated: oldData.sensorDateCreated,
                sensorLastUpdated: oldData.sensorLastUpdated,
                sensorMacAddress: oldData.sensorMacAddress,
                sensorUUID: oldData.sensorUUID,
                sensorIsUpgradable: oldData.sensorIsUpgradable
            )
            
            if let oldName = airComfortInfoViewModel.sensorData.value?.sensorName,
               let oldPeriod = airComfortInfoViewModel.sensorData.value?.sensorPeriod {
                if (oldName != name || oldPeriod != period) {
                    temporarySensorListCellData = data
                    animateRefreshButton()
                }
            }
            
            airComfortInfoViewModel.sensorDataChanged(data: data)
        }
    }
    
    @objc private func TemperatureRangeChanged(_ notification: Notification) {
        guard let min = notification.userInfo?["min"] as? Int,
            let max = notification.userInfo?["max"] as? Int,
            let address = notification.userInfo?["address"] as? String,
            let name = notification.userInfo?["name"] as? String else {
                Globals.log("Temperature Ranges Invalid")
                
                return
        }
        
        tempUpperLimit = Double(max).rounded()
        tempLowerLimit = Double(min).rounded()
        
        // Check range for Notification
        if let st = sensorTemperature.text, let timestamp = airComfortInfoViewModel.vTimeStamp.value {
            if let temp = Float(st.trimmingCharacters(in: TktConstants.CharSet.climateDigits.inverted)), let timestampInt = Int64(timestamp) {
                let maxTemp = Float(tempUpperLimit!)
                let minTemp = Float(tempLowerLimit!)
                let timestampNSNumber = NSNumber(value: timestampInt)
                
                if (temp >= maxTemp) {
                    
                    if (airComfortInfoViewModel.coreDataManager.checkNotificationExist(addressNewsType: "\(address)\(TktConstants.NewsCode.TEMPERATURE_VERY_HIGH)")) {
                        airComfortInfoViewModel.coreDataManager.updateNotification(
                            sensorName: name,
                            addressNewsType: "\(address)\(TktConstants.NewsCode.TEMPERATURE_VERY_HIGH)",
                            timestamp: timestampNSNumber
                        )
                    } else {
                        let newsType = NSNumber(value: TktConstants.NewsCode.TEMPERATURE_VERY_HIGH)
                        
                        NotificationCenter.default.post(name: Notification.Name(rawValue: TktConstants.Notification.AppendAlertNotification), object: nil, userInfo: ["address": address, "name": name, "addressNewsType": "\(address)\(TktConstants.NewsCode.TEMPERATURE_VERY_HIGH)", "timestamp": timestampNSNumber, "newsType": newsType])
                        
                        airComfortInfoViewModel.coreDataManager.saveNotification(
                            macAddress: address,
                            sensorName: name,
                            addressNewsType: "\(address)\(TktConstants.NewsCode.TEMPERATURE_VERY_HIGH)",
                            timestamp: timestampNSNumber,
                            newsType: newsType
                        )
                    }
                    
                } else if (temp <= minTemp) {
                    
                    if (airComfortInfoViewModel.coreDataManager.checkNotificationExist(addressNewsType: "\(address)\(TktConstants.NewsCode.TEMPERATURE_VERY_LOW)")) {
                        airComfortInfoViewModel.coreDataManager.updateNotification(
                            sensorName: name,
                            addressNewsType: "\(address)\(TktConstants.NewsCode.TEMPERATURE_VERY_LOW)",
                            timestamp: timestampNSNumber
                        )
                    } else {
                        let newsType = NSNumber(value: TktConstants.NewsCode.TEMPERATURE_VERY_LOW)
                        
                        NotificationCenter.default.post(name: Notification.Name(rawValue: TktConstants.Notification.AppendAlertNotification), object: nil, userInfo: ["address": address, "name": name, "addressNewsType": "\(address)\(TktConstants.NewsCode.TEMPERATURE_VERY_LOW)", "timestamp": timestampNSNumber, "newsType": newsType])
                        
                        airComfortInfoViewModel.coreDataManager.saveNotification(
                            macAddress: address,
                            sensorName: name,
                            addressNewsType: "\(address)\(TktConstants.NewsCode.TEMPERATURE_VERY_LOW)",
                            timestamp: timestampNSNumber,
                            newsType: newsType
                        )
                    }
                    
                }
                
            }
        }
    }
    
    @objc private func HumidityRangeChanged(_ notification: Notification) {
        guard let min = notification.userInfo?["min"] as? Int,
            let max = notification.userInfo?["max"] as? Int,
            let address = notification.userInfo?["address"] as? String,
            let name = notification.userInfo?["name"] as? String else {
                Globals.log("Humidity Ranges Invalid")
                
                return
        }
        
        humUpperLimit = Double(max).rounded()
        humLowerLimit = Double(min).rounded()
        
        // Check range for Notification
        if let sh = sensorHumidity.text, let timestamp = airComfortInfoViewModel.vTimeStamp.value {
            if let hum = Float(sh.trimmingCharacters(in: TktConstants.CharSet.climateDigits.inverted)), let timestampInt = Int64(timestamp) {
                let maxHum = Float(humUpperLimit!)
                let minHum = Float(humLowerLimit!)
                let timestampNSNumber = NSNumber(value: timestampInt)
                
                if (hum >= maxHum) {
                    
                    if (airComfortInfoViewModel.coreDataManager.checkNotificationExist(addressNewsType: "\(address)\(TktConstants.NewsCode.HUMIDITY_VERY_HIGH)")) {
                        airComfortInfoViewModel.coreDataManager.updateNotification(
                            sensorName: name,
                            addressNewsType: "\(address)\(TktConstants.NewsCode.HUMIDITY_VERY_HIGH)",
                            timestamp: timestampNSNumber
                        )
                    } else {
                        let newsType = NSNumber(value: TktConstants.NewsCode.HUMIDITY_VERY_HIGH)
                        
                        NotificationCenter.default.post(name: Notification.Name(rawValue: TktConstants.Notification.AppendAlertNotification), object: nil, userInfo: ["address": address, "name": name, "addressNewsType": "\(address)\(TktConstants.NewsCode.HUMIDITY_VERY_HIGH)", "timestamp": timestampNSNumber, "newsType": newsType])
                        
                        airComfortInfoViewModel.coreDataManager.saveNotification(
                            macAddress: address,
                            sensorName: name,
                            addressNewsType: "\(address)\(TktConstants.NewsCode.HUMIDITY_VERY_HIGH)",
                            timestamp: timestampNSNumber,
                            newsType: newsType
                        )
                    }
                    
                } else if (hum <= minHum) {
                    
                    if (airComfortInfoViewModel.coreDataManager.checkNotificationExist(addressNewsType: "\(address)\(TktConstants.NewsCode.HUMIDITY_VERY_LOW)")) {
                        airComfortInfoViewModel.coreDataManager.updateNotification(
                            sensorName: name,
                            addressNewsType: "\(address)\(TktConstants.NewsCode.HUMIDITY_VERY_LOW)",
                            timestamp: timestampNSNumber
                        )
                    } else {
                        let newsType = NSNumber(value: TktConstants.NewsCode.HUMIDITY_VERY_LOW)
                        
                        NotificationCenter.default.post(name: Notification.Name(rawValue: TktConstants.Notification.AppendAlertNotification), object: nil, userInfo: ["address": address, "name": name, "addressNewsType": "\(address)\(TktConstants.NewsCode.HUMIDITY_VERY_LOW)", "timestamp": timestampNSNumber, "newsType": newsType])
                        
                        airComfortInfoViewModel.coreDataManager.saveNotification(
                            macAddress: address,
                            sensorName: name,
                            addressNewsType: "\(address)\(TktConstants.NewsCode.HUMIDITY_VERY_LOW)",
                            timestamp: timestampNSNumber,
                            newsType: newsType
                        )
                    }
                    
                }
                
            }
        }
    }
    
    // MARK: Actions
    @IBAction func onIconPressed(_ sender: Any) {
        if (airComfortInfoViewModel.queueManager.sensorDetails.value.count > 0) {
            
            let alert = UIAlertController(title: NSLocalizedString("device_busy", comment: ""), message: NSLocalizedString("wait_bt_process", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let coverFlowViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "coverFlowViewControllerId") as! CoverflowViewController
        if let sensorType = sensorData?.sensorType {
            coverFlowViewController.sensorType = sensorType
            coverFlowViewController.delegate = self
            coverFlowViewController.modalPresentationStyle = .overCurrentContext
            self.present(coverFlowViewController, animated: false, completion: nil)
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.isNavigationBarHidden = true
        NotificationCenter.default.removeObserver(self)
        _ = navigationController?.popViewController(animated: false)
    }
    
    @IBAction func refreshButton(_ sender: Any) {
        
        if (!airComfortInfoViewModel.coreBluetoothManager.isBluetoothPoweredOn) {
            self.showAlertforSettings(NSLocalizedString("bluetooth_turn_off", comment: ""))
            
            return
        }
        
        if !isRefreshButtonRotating {
            isRefreshButtonRotating = true
            
            let spinAnimation = CABasicAnimation()
            spinAnimation.fromValue = 0
            spinAnimation.toValue = CGFloat.pi * 2
            spinAnimation.duration = 1
            spinAnimation.repeatCount = Float.infinity
            spinAnimation.isRemovedOnCompletion = false
            spinAnimation.fillMode = kCAFillModeForwards
            spinAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            
            refreshButton.layer.add(spinAnimation, forKey: "transform.rotation.z")
            refreshButton.isEnabled = false
            refreshButton.layer.shadowOpacity = 0.00
            
            airComfortInfoViewModel.refreshSensor()
        }
    }
    
    public func animateRefreshButton() {
        if !isRefreshButtonRotating {
            isRefreshButtonRotating = true
            
            let spinAnimation = CABasicAnimation()
            spinAnimation.fromValue = 0
            spinAnimation.toValue = CGFloat.pi * 2
            spinAnimation.duration = 1
            spinAnimation.repeatCount = Float.infinity
            spinAnimation.isRemovedOnCompletion = false
            spinAnimation.fillMode = kCAFillModeForwards
            spinAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            
            refreshButton.layer.add(spinAnimation, forKey: "transform.rotation.z")
            refreshButton.isEnabled = false
            refreshButton.layer.shadowOpacity = 0.00
        }
    }
    
    @IBAction func previousButtonPressed(_ sender: Any) {
        showActivityIncidator()
        freezeControls()
        
        currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate!)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd"
        let dateString = dateFormatter.string(from: currentDate!)
        datePicker.setTitle(dateString, for: .normal)
        
        dateFormatter.dateFormat = "MM-dd-yyyy"
        
        let date1 = dateFormatter.string(from: now!)
        let date2 = dateFormatter.string(from: currentDate!)
        
        nextButton.isEnabled = (date1 == date2) ? false : true
        
        let from = NSNumber(value: (currentDate?.startOfDay.timeIntervalSince1970)!)
        let to = NSNumber(value: (currentDate?.endOfDay.timeIntervalSince1970)!)
        airComfortInfoViewModel.generateData(from: from, to: to)
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        let newDate = calendar.date(byAdding: .day, value: 1, to: currentDate!)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        
        let date1 = dateFormatter.string(from: now!)
        let date2 = dateFormatter.string(from: currentDate!)
        
        if (date1 != date2) {
            showActivityIncidator()
            freezeControls()
            
            // Set Current Date to Selected Date
            currentDate = newDate
            let formatDate = dateFormatter.string(from: currentDate!)
            
            if (date1 == formatDate) {
                datePicker.setTitle(NSLocalizedString("today", comment: ""), for: .normal)
                nextButton.isEnabled = false
            } else {
                dateFormatter.dateFormat = "MMM dd"
                let dateString = dateFormatter.string(from: currentDate!)
                datePicker.setTitle(dateString, for: .normal)
                nextButton.isEnabled = true
            }
            
            let from = NSNumber(value: (currentDate?.startOfDay.timeIntervalSince1970)!)
            let to = NSNumber(value: (currentDate?.endOfDay.timeIntervalSince1970)!)
            airComfortInfoViewModel.generateData(from: from, to: to)
        }
    }
    
    func chartSegmentedValueChanged(_ sender: AnyObject?) {
        showActivityIncidator()
        freezeControls()
        
        switch chartSegmentedControl.selectedIndex {
        case 0:
            datePicker.isHidden = false
            previousButton.isHidden = false
            nextButton.isHidden = false
            
            monthPicker.isHidden = true
            yearPicker.isHidden = true
            weeklyLabel.isHidden = true
            
            airComfortInfoViewModel.selectedChartTab = TktConstants.Tab.Day
            
            // Generate Today's Data in Chart
            let from = NSNumber(value: (currentDate?.startOfDay.timeIntervalSince1970)!)
            let to = NSNumber(value: (currentDate?.endOfDay.timeIntervalSince1970)!)
            airComfortInfoViewModel.generateData(from: from, to: to)
            
        case 1:
            weeklyLabel.isHidden = false
            
            datePicker.isHidden = true
            previousButton.isHidden = true
            nextButton.isHidden = true
            monthPicker.isHidden = true
            yearPicker.isHidden = true
            
            airComfortInfoViewModel.selectedChartTab = TktConstants.Tab.Weekly
            
            // Generate Weekly Data in Chart
            let from = NSNumber(value: (lastWeekDate?.startOfDay.timeIntervalSince1970)!)
            let to = NSNumber(value: (now?.endOfDay.timeIntervalSince1970)!)
            airComfortInfoViewModel.generateData(from: from, to: to)
            
        case 2:
            monthPicker.isHidden = false
            yearPicker.isHidden = false
            
            datePicker.isHidden = true
            previousButton.isHidden = true
            nextButton.isHidden = true
            weeklyLabel.isHidden = true
            
            airComfortInfoViewModel.selectedChartTab = TktConstants.Tab.Monthly
            
            // Generate Monthly Data in Chart
            let components = DateComponents(year: selectedYear!, month: selectedMonth! + 1)
            if let startOfMonth = calendar.date(from: components) {
                
                var lastDayComponent = DateComponents()
                lastDayComponent.month = 1
                lastDayComponent.day = -1
                let endOfMonth = calendar.date(byAdding: lastDayComponent, to: startOfMonth)
                
                let from = NSNumber(value: startOfMonth.timeIntervalSince1970)
                let to = NSNumber(value: (endOfMonth?.timeIntervalSince1970)!)
                
                airComfortInfoViewModel.generateData(from: from, to: to)
            }
            
        default:
            return
        }
    }
    
    // MARK: CoverflowViewControllerDelegate
    func didFinishPickingMediaWithInfo(_ image: UIImage) {
        DispatchQueue.global(qos: .userInteractive).sync {
            let imageSize = CGSize(width: 500, height: 500)
            let sensorImage = Globals.resizeImage(image, targetSize: imageSize)
            airComfortInfoViewModel.updateSensorPhoto(image: sensorImage)
        }
    }
    
    func didFinishPickingImageInCoverflow(_ image: UIImage, imageCode: Int) {
        var sensorType: String = ""
        
        switch imageCode {
        case 0:
            sensorType = NSLocalizedString("air_comfort", comment: "")
        case 1:
            sensorType = NSLocalizedString("baby_room", comment: "")
        case 2:
            sensorType = NSLocalizedString("bedroom", comment: "")
        case 3:
            sensorType = NSLocalizedString("dining_room", comment: "")
        case 4:
            sensorType = NSLocalizedString("kitchen", comment: "")
        case 5:
            sensorType = NSLocalizedString("living_room", comment: "")
        case 6:
            sensorType = NSLocalizedString("toilet", comment: "")
        default:
            return
        }
        
        if let address = sensorData?.sensorMacAddress {
            let roomTypeKey: String = "\(address)\(TktConstants.Key.roomType)"
            preferences.set(sensorType, forKey: roomTypeKey)
            
            preferences.synchronize()
        }
        
        DispatchQueue.global(qos: .userInteractive).sync {
            let imageSize = CGSize(width: 500, height: 500)
            let sensorImage = Globals.resizeImage(image, targetSize: imageSize)
            airComfortInfoViewModel.updateSensorPhoto(image: sensorImage)
        }
    }
    
    func formatCallingViewNavigation() {
        self.navigationController?.colorNavigationBar()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @objc fileprivate func syncCharts(srcChart: ChartHelper, dstChart: ChartHelper) {
        
        if dstChart.isHidden {
            return
        }
        
        let srcMatrix = srcChart.viewPortHandler.touchMatrix
        let dstMatrix = dstChart.viewPortHandler.touchMatrix
        
        let newMatrix = CGAffineTransform.init(a: srcMatrix.a,
                                               b: dstMatrix.b,
                                               c: srcMatrix.c,
                                               d: dstMatrix.d,
                                               tx: srcMatrix.tx,
                                               ty: dstMatrix.ty)
        
        let _ = dstChart.viewPortHandler.refresh(newMatrix: newMatrix, chart: dstChart, invalidate: true)
    }
}

// MARK: ChartViewDelegate
extension AirComfortInfoViewController: ChartViewDelegate {
    
    fileprivate func chartViewChecker(_ chartView: ChartViewBase) {
        if (chartView == self.mChartTop) {
            syncCharts(srcChart: self.mChartTop, dstChart: self.mChartBottom)
        } else if (chartView == self.mChartBottom) {
            syncCharts(srcChart: self.mChartBottom, dstChart: self.mChartTop)
        }
    }
    
    public func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        chartViewChecker(chartView)
    }
    
    public func chartValueNothingSelected(_ chartView: ChartViewBase) {
        chartViewChecker(chartView)
    }
    
    public func chartTranslated(_ chartView: ChartViewBase, dX: CGFloat, dY: CGFloat) {
        chartViewChecker(chartView)
    }
    
    public func chartScaled(_ chartView: ChartViewBase, scaleX: CGFloat, scaleY: CGFloat) {
        chartViewChecker(chartView)
    }
}
