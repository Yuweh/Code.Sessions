//
//

import UIKit
import RxCocoa
import RxSwift
import Charts

class AirQualityInfoViewController: UIViewController, CoverflowViewControllerDelegate {
    
    let disposeBag = DisposeBag()
    
    // AirSensor Outlets
    @IBOutlet weak var airSensorDataContainer: UIView!
    @IBOutlet weak var batteryImage_as: UIImageView!
    @IBOutlet weak var batteryLabel_as: UILabel!
    @IBOutlet weak var sensorIcon_as: UIButton!
    @IBOutlet weak var firmwareVersion_as: UILabel!
    
    @IBOutlet weak var sensorTemperature_as: UILabel!
    @IBOutlet weak var sensorHumidity_as: UILabel!
    @IBOutlet weak var sensorLux: UILabel!
    @IBOutlet weak var sensorDecibel: UILabel!
    
    // AirQuality Outlets
    @IBOutlet weak var sensorIconContainer: UIView!
    @IBOutlet weak var batteryImage: UIImageView!
    @IBOutlet weak var batteryLabel: UILabel!
    @IBOutlet weak var sensorIcon: UIButton!
    @IBOutlet weak var firmwareVersion: UILabel!
    
    @IBOutlet weak var dataContainer: UIView!
    @IBOutlet weak var sensorTemperature: UILabel!
    @IBOutlet weak var sensorHumidity: UILabel!
    @IBOutlet weak var sensorVOC: UILabel!
    @IBOutlet weak var sensorCO2: UILabel!
    
    @IBOutlet weak var temperatureIcon: UIImageView!
    @IBOutlet weak var humidityIcon: UIImageView!
    @IBOutlet weak var vocIcon: UIImageView!
    @IBOutlet weak var co2Icon: UIImageView!
    
    @IBOutlet weak var lastUpdatedTimestamp: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var previousButton: CustomButton!
    @IBOutlet weak var nextButton: CustomButton!
    @IBOutlet weak var weeklyLabel: UILabel!
    @IBOutlet weak var datePicker: CustomButton!
    @IBOutlet weak var monthPicker: CustomButton!
    @IBOutlet weak var yearPicker: CustomButton!
    
    @IBOutlet weak var chartSegmentedControl: CustomSegmentedControl!
    @IBOutlet weak var dataTypeSegmentedControl: CustomSegmentedControl!
    
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var sensorData: sensorListCellData?
    var indexPath: IndexPath?
    let airQualityInfoViewModel = AirQualityInfoViewModel()
    
    var isRefreshButtonRotating = false
    var now: Date?
    var currentDate: Date?
    var lastWeekDate: Date?
    var selectedMonth: Int?
    var selectedYear: Int?
    
    var xAxisValueFormatter: IAxisValueFormatter?
    var dataSetFillFormatter: IFillFormatter?
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
        Globals.log("AirQualityInfoViewController init()")
        
        // Add NotificationCenter Observer for Sensor Connection Failed
        NotificationCenter.default.addObserver(self, selector: #selector(AirQualityInfoViewController.sensorConnectionFailed(_:)), name: NSNotification.Name(rawValue: TktConstants.Notification.ConnectionFailedNotification), object: nil)
        
        // Add NotificationCenter Observer for Update Data Peripherals
        NotificationCenter.default.addObserver(self, selector: #selector(AirQualityInfoViewController.updateSensorData(_:)), name: NSNotification.Name(rawValue: TktConstants.Notification.SensorDataUpdateNotification), object: nil)
        
        // Add NotificationCenter Observer for Update UI
        NotificationCenter.default.addObserver(self, selector: #selector(AirQualityInfoViewController.updateSensorData(_:)), name: NSNotification.Name(rawValue: TktConstants.Notification.SensorDataUpdateUINotification), object: nil)
        
        // Add NotificationCenter Observer for DatePicker
        NotificationCenter.default.addObserver(self, selector: #selector(AirQualityInfoViewController.newDatePicked(_:)), name: NSNotification.Name(rawValue: TktConstants.Notification.DatePickerNotification), object: nil)
        
        // Add NotificationCenter Observer for MonthPicker
        NotificationCenter.default.addObserver(self, selector: #selector(AirQualityInfoViewController.newMonthPicked(_:)), name: NSNotification.Name(rawValue: TktConstants.Notification.MonthPickerNotification), object: nil)
        
        // Add NotificationCenter Observer for YearPicker
        NotificationCenter.default.addObserver(self, selector: #selector(AirQualityInfoViewController.newYearPicked(_:)), name: NSNotification.Name(rawValue: TktConstants.Notification.YearPickerNotification), object: nil)
        
        // Add NotificationCenter Observer for DismissModal in MonthPicker and YearPicker
        NotificationCenter.default.addObserver(self, selector: #selector(AirQualityInfoViewController.fromDismissModal(_:)), name: NSNotification.Name(rawValue: TktConstants.Notification.DismissModalNotification), object: nil)
        
        // Add NotificationCenter Observer for downloadLogChartRefresh
        NotificationCenter.default.addObserver(self, selector: #selector(AirQualityInfoViewController.downloadLogsChartRefresh(_:)), name: NSNotification.Name(rawValue: TktConstants.Notification.DownloadLogsNotification), object: nil)
        
        // Add NotificationCenter Observer for immediateReadChartRefresh
        NotificationCenter.default.addObserver(self, selector: #selector(AirQualityInfoViewController.immediateReadChartRefresh(_:)), name: NSNotification.Name(rawValue: TktConstants.Notification.DoImmediateReadNotification), object: nil)
        
        // Add NotifcationCenter Observer for formatNavigationFromInfoNotification
        NotificationCenter.default.addObserver(self, selector: #selector(AirQualityInfoViewController.formatNavigationBar(_:)), name: NSNotification.Name(rawValue: TktConstants.Notification.FormatNavigationFromInfoNotification), object: nil)
        
        // Add NotificationCenter Observer for SensorDataChangedNotification
        NotificationCenter.default.addObserver(self, selector: #selector(AirQualityInfoViewController.sensorDataChanged(_:)), name: NSNotification.Name(rawValue: TktConstants.Notification.SensorDataChangedNotification), object: nil)
        
        // Add NotificationCenter Observer for TemperatureRangeChangedNotification
        NotificationCenter.default.addObserver(self, selector: #selector(AirQualityInfoViewController.TemperatureRangeChanged(_:)), name:  NSNotification.Name(rawValue: TktConstants.Notification.TemperatureRangeChangedNotification), object: nil)
        
        // Add NotificationCenter Observer for HumidityRangeChangedNotification
        NotificationCenter.default.addObserver(self, selector: #selector(AirQualityInfoViewController.HumidityRangeChanged(_:)), name: NSNotification.Name(rawValue: TktConstants.Notification.HumidityRangeChangedNotification), object: nil)
        
        // Add NotificationCenter Observer for DecibelRangeChangedNotification
        NotificationCenter.default.addObserver(self, selector: #selector(AirQualityInfoViewController.DecibelRangeChanged(_:)), name: NSNotification.Name(rawValue: TktConstants.Notification.DecibelRangeChangedNotification), object: nil)
        
        // Add NotificationCenter Observer for LuxRangeChangedNotification
        NotificationCenter.default.addObserver(self, selector: #selector(AirQualityInfoViewController.LuxRangeChanged(_:)), name: NSNotification.Name(rawValue: TktConstants.Notification.LuxRangeChangedNotification), object: nil)
        
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
            airQualityInfoViewModel.assignDataSource(indexPath: ip, sensor: data)
            
            self.navigationController?.navigationBar.topItem?.title = data.sensorName

            let titleAttributes = Globals.isAirComfort() ? [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Antenna-Light", size: 17)!] :[NSForegroundColorAttributeName: TktConstants.Color.AirSensor.GrayTextColor]
            self.navigationController?.navigationBar.titleTextAttributes = titleAttributes
            
            if (!Globals.isAirComfort()) {
                displayAirSensorView()
                loadECAirSensorObservableViews()
            } else {
                chartSegmentedControl.titles = [NSLocalizedString("day", comment: ""), NSLocalizedString("seven_days", comment: ""), NSLocalizedString("monthly", comment: "")]
                chartSegmentedControl.font = UIFont(name: "Antenna-Light", size: 12)!
                dataTypeSegmentedControl.titles = [
                    NSLocalizedString("temp", comment: ""),
                    NSLocalizedString("humid", comment: ""),
                    NSLocalizedString("voc", comment: ""),
                    NSLocalizedString("co2", comment: "")
                ]
                dataTypeSegmentedControl.font = UIFont(name: "Antenna-Light", size: 12)!
                loadAirQualityObservableViews()
            }
            
            chartSegmentedControl.addTarget(self, action: #selector(AirQualityInfoViewController.chartSegmentedValueChanged(_:)), for: .valueChanged)
            dataTypeSegmentedControl.addTarget(self, action: #selector(AirQualityInfoViewController.dataTypeSegmentedValueChanged(_:)), for: .valueChanged)

            
            _ = airQualityInfoViewModel.vTimeStamp.asObservable().subscribe { value in
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
        if (airQualityInfoViewModel.isSensorCurrentlyDownloading()) {
            animateRefreshButton()
            
            // This is Download Process
            if let _ = airQualityInfoViewModel.coreBluetoothManager.peripheralLoggerCtrlCharacteristics[(sensorData?.sensorUUID)!] {
                airQualityInfoViewModel.refreshType = TktConstants.Notification.DownloadLogsNotification
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
        
        formatChart()
        
        // Generate Today's Data in
        let from = NSNumber(value: (currentDate?.startOfDay.timeIntervalSince1970)!)
        let to = NSNumber(value: (currentDate?.endOfDay.timeIntervalSince1970)!)
        airQualityInfoViewModel.generateData(from: from, to: to)
        
        if let address = airQualityInfoViewModel.sensorData.value?.sensorMacAddress {
            assignTemperatureLimitLines(address: address)
            assignHumidityLimitLines(address: address)
            
            if (!Globals.isAirComfort()) {
                assignDecibelLimitLines(address: address)
                assignLuxLimitLines(address: address)
            }
        }
        
        _ = airQualityInfoViewModel.viewVariable.asObservable().subscribe { value in
            self.freezeControls()
            
            if (self.airQualityInfoViewModel.xAxisLabels.value.count > 0 && 0 < self.airQualityInfoViewModel.yAxisLabels.value.count) {
                switch self.dataTypeSegmentedControl.selectedIndex {
                case 0:
                    if let lLimit = self.tempLowerLimit, let hLimit = self.tempUpperLimit {
                        self.airQualityInfoViewModel.lowerLimit = lLimit
                        self.airQualityInfoViewModel.upperLimit = hLimit
                    }
                    
                    if (self.preferences.integer(forKey: TktConstants.Key.UnitPreference) == 1) {
                        let maxArray: [Double] = [self.airQualityInfoViewModel.upperLimit, self.airQualityInfoViewModel.yAxisLabels.value.max()!.rounded(), 100.0]
                        let minArray: [Double] = [self.airQualityInfoViewModel.lowerLimit, self.airQualityInfoViewModel.yAxisLabels.value.min()!.rounded(), 50.0]
                        
                        self.lineChartView.leftAxis.axisMaximum = maxArray.max()!
                        self.lineChartView.leftAxis.axisMinimum = minArray.min()!
                    } else {
                        let maxArray: [Double] = [self.airQualityInfoViewModel.upperLimit, self.airQualityInfoViewModel.yAxisLabels.value.max()!.rounded(), 40.0]
                        let minArray: [Double] = [self.airQualityInfoViewModel.lowerLimit, self.airQualityInfoViewModel.yAxisLabels.value.min()!.rounded(), 10.0]
                        
                        self.lineChartView.leftAxis.axisMaximum = maxArray.max()!
                        self.lineChartView.leftAxis.axisMinimum = minArray.min()!
                    }
                    
                    self.checkLimitLines()
                    
                case 1:
                    if let lLimit = self.humLowerLimit, let hLimit = self.humUpperLimit {
                        self.airQualityInfoViewModel.lowerLimit = lLimit
                        self.airQualityInfoViewModel.upperLimit = hLimit
                    }
                    
                    self.lineChartView.leftAxis.axisMaximum = 100.0
                    self.lineChartView.leftAxis.axisMinimum = 0.0
                    self.checkLimitLines()
                    
                case 2:
                    self.airQualityInfoViewModel.upperLimit = 0.0
                    self.airQualityInfoViewModel.lowerLimit = 0.0
                    
                    if (Globals.isAirComfort()) {
                        // VOC AIRCOMFORT
                        self.lineChartView.leftAxis.axisMaximum = (self.airQualityInfoViewModel.yAxisLabels.value.max()! >  TktConstants.Default.VOC_THRESHOLD_MAX)
                            ? self.airQualityInfoViewModel.yAxisLabels.value.max()! : TktConstants.Default.VOC_THRESHOLD_MAX
                        self.lineChartView.leftAxis.axisMinimum = 0.0
                        
                    } else {
                        // DECIBEL AIRSENSOR
                        self.lineChartView.leftAxis.axisMinimum = 0.0
                        self.lineChartView.leftAxis.axisMaximum = 150.0
                    }
                    
                    self.checkLimitLines()
                    
                case 3:
                    self.airQualityInfoViewModel.upperLimit = 0.0
                    self.airQualityInfoViewModel.lowerLimit = 0.0
                    if (Globals.isAirComfort()) {
                        // CO2 AIRCOMFORT
                        self.lineChartView.leftAxis.axisMaximum = (self.airQualityInfoViewModel.yAxisLabels.value.max()! >  TktConstants.Default.CO2_THRESHOLD_MAX) ? self.airQualityInfoViewModel.yAxisLabels.value.max()! : TktConstants.Default.CO2_THRESHOLD_MAX
                        self.lineChartView.leftAxis.axisMinimum = 100.0
                        
                    } else {
                        // LUX AIRSENSOR
                        self.lineChartView.leftAxis.axisMinimum = 0.0
                        self.lineChartView.leftAxis.axisMaximum = 1000.0
                    }
                    
                    self.checkLimitLines()
                case 4:
                    // CO2 or VOC AirSensor?
                    self.airQualityInfoViewModel.upperLimit = 0.0
                    self.airQualityInfoViewModel.lowerLimit = 0.0
                    self.lineChartView.leftAxis.axisMaximum = 100.0
                    self.lineChartView.leftAxis.axisMinimum = 0
                    
                    self.checkLimitLines()
                default:
                    return
                }
                
                self.displayChartData(datas: self.airQualityInfoViewModel.xAxisLabels.value)
            } else {
                self.clearChartData()
                
                self.lineChartView.noDataText = (!self.airQualityInfoViewModel.isFetchEmpty) ? NSLocalizedString("no_data_available_text", comment: "") : NSLocalizedString("no_data_text", comment: "")
            }
            
            if (!self.activityIndicator.isHidden) {
                self.activityIndicator.isHidden = true
            }
            
            if (self.lineChartView.isHidden) {
                self.lineChartView.isHidden = false
            }
            }
            .addDisposableTo(disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isUserInteractionEnabled = true
        
        // Refresh Last Sync Timestamp
        airQualityInfoViewModel.refreshLastSyncTimeStamp()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        airQualityInfoViewModel.stopTimer()
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
            infoViewController.sensorData = airQualityInfoViewModel.sensorData.value
            
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
    private func loadAirQualityObservableViews() {
        _ = airQualityInfoViewModel.vBatteryImage.asObservable().subscribe { value in
            if let element = value.element {
                self.batteryImage.image = element
            }
            }
            .addDisposableTo(disposeBag)
        
        _ = airQualityInfoViewModel.vBatteryLabel.asObservable().subscribe { value in
            if let element = value.element {
                self.batteryLabel.text = element
            }
            }
            .addDisposableTo(disposeBag)
        
        _ = airQualityInfoViewModel.vSensorIcon.asObservable().subscribe { value in
            if let element = value.element {
                DispatchQueue.global(qos: .userInteractive).sync {
                    self.sensorIcon.setImage(element, for: .normal)
                    self.sensorIcon.imageView?.contentMode = .scaleAspectFill
                }
            }
            }
            .addDisposableTo(disposeBag)
        
        _ = airQualityInfoViewModel.vFirmwareVersion.asObservable().subscribe { value in
            if let element = value.element {
                self.firmwareVersion.text = element
            }
            }
            .addDisposableTo(disposeBag)
        
        _ = airQualityInfoViewModel.vSensorTemperature.asObservable().subscribe { value in
            if let temperature = value.element ?? nil, let address = self.airQualityInfoViewModel.sensorData.value?.sensorMacAddress {
                self.temperatureIcon.image = Globals.getIconImage(view: TktConstants.CallingView.AirQualityInfoViewController, preferences: self.preferences, value: temperature, dataType: TktConstants.Key.attrTemperature, address: address)
                self.sensorTemperature.textColor = Globals.getTemperatureTextColor(view: TktConstants.CallingView.AirQualityInfoViewController, preferences: self.preferences, temperature: temperature, address: address)
                self.sensorTemperature.text = Globals.getDataText(preferences: self.preferences, data: temperature, isTemperature: true)
            }
            }
            .addDisposableTo(disposeBag)
        
        _ = airQualityInfoViewModel.vSensorHumidity.asObservable().subscribe { value in
            if let humidity = value.element ?? nil, let address = self.airQualityInfoViewModel.sensorData.value?.sensorMacAddress {
                self.humidityIcon.image = Globals.getIconImage(view: TktConstants.CallingView.AirQualityInfoViewController, preferences: self.preferences, value: humidity, dataType: TktConstants.Key.attrHumidity, address: address)
                self.sensorHumidity.textColor = Globals.getHumidityTextColor(view: TktConstants.CallingView.AirQualityInfoViewController, preferences: self.preferences, humidity: humidity, address: address)
                self.sensorHumidity.text = Globals.getDataText(preferences: self.preferences, data: humidity, isTemperature: false)
            }
            }
            .addDisposableTo(disposeBag)
        
        _ = airQualityInfoViewModel.vSensorCO2.asObservable().subscribe { value in
            if let element = value.element {
                
                if let co2 = Double(element!.trimmingCharacters(in: TktConstants.CharSet.climateDigits.inverted)),
                   let voc = Double(self.airQualityInfoViewModel.vSensorVOC.value!.trimmingCharacters(in: TktConstants.CharSet.climateDigits.inverted)),
                   let address = self.airQualityInfoViewModel.sensorData.value?.sensorMacAddress,
                   let vSensorVOC = self.airQualityInfoViewModel.vSensorVOC.value {
                    
                    self.co2Icon.image = Globals.getIconImage(view: TktConstants.CallingView.AirQualityInfoViewController, preferences: self.preferences, value: "\(co2)", dataType: TktConstants.Key.attrCO2, address: address)
                    self.sensorCO2.textColor = (co2 > TktConstants.Default.CO2_THRESHOLD_MAX) ? TktConstants.Color.AirComfort.WarningTextColor : TktConstants.Color.Basic.White
                    self.sensorCO2.text = (co2 == TktConstants.QualityLevels.Invalid) ? "" : element
                    
                    self.vocIcon.image = Globals.getIconImage(view: TktConstants.CallingView.AirQualityInfoViewController, preferences: self.preferences, value: "\(voc)", dataType: TktConstants.Key.attrVOC, address: address)
                    self.sensorVOC.textColor = (((voc > TktConstants.Default.VOC_THRESHOLD_MAX) || (voc <= 0.0))) ? TktConstants.Color.AirComfort.WarningTextColor : TktConstants.Color.Basic.White
                    self.sensorVOC.text = (co2 == TktConstants.QualityLevels.Invalid) ? "" : vSensorVOC
                }
            }
            }
            .addDisposableTo(disposeBag)
    }
    
    private func loadECAirSensorObservableViews() {
        _ = airQualityInfoViewModel.vBatteryImage_as.asObservable().subscribe { value in
            if let element = value.element ?? nil {
                self.batteryImage_as.image = element
            }
            }
            .addDisposableTo(disposeBag)
        
        _ = airQualityInfoViewModel.vBatteryLabel_as.asObservable().subscribe { value in
            if let element = value.element ?? nil {
                self.batteryLabel_as.text = element
            }
            }
            .addDisposableTo(disposeBag)
        
        _ = airQualityInfoViewModel.vSensorIcon_as.asObservable().subscribe { value in
            if let element = value.element ?? nil {
                self.sensorIcon_as.setImage(element, for: .normal)
                self.sensorIcon_as.imageView?.contentMode = .scaleAspectFill
            }
            }
            .addDisposableTo(disposeBag)
        
        _ = airQualityInfoViewModel.vFirmwareVersion_as.asObservable().subscribe { value in
            if let element = value.element ?? nil {
                self.firmwareVersion_as.text = element
            }
            }
            .addDisposableTo(disposeBag)
        
        _ = airQualityInfoViewModel.vSensorTemperature_as.asObservable().subscribe { value in
            if let temperature = value.element ?? nil {
                self.sensorTemperature_as.text = Globals.getDataText(preferences: self.preferences, data: temperature, isTemperature: true)
            }
            }
            .addDisposableTo(disposeBag)
        
        _ = airQualityInfoViewModel.vSensorHumidity_as.asObservable().subscribe { value in
            if let humidity = value.element ?? nil {
                self.sensorHumidity_as.text = Globals.getDataText(preferences: self.preferences, data: humidity, isTemperature: false)
            }
            }
            .addDisposableTo(disposeBag)
        
        _ = airQualityInfoViewModel.vSensorLux.asObservable().subscribe { value in
            if let element = value.element ?? nil {
                self.sensorLux.text = element
            }
            }
            .addDisposableTo(disposeBag)
        
        _ = airQualityInfoViewModel.vSensorDecibel.asObservable().subscribe { value in
            if let element = value.element ?? nil {
                self.sensorDecibel.text = element
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
    
    private func formatChart() {
        self.xAxisValueFormatter = DynamicXAxisFormatter(chart: self.lineChartView)
        self.dataSetFillFormatter = DataSetFillFormatter()
        lineChartView.delegate = self
        lineChartView.gridBackgroundColor = (Globals.isAirComfort()) ? TktConstants.Color.AirComfort.GridBackgroundColor : TktConstants.Color.AirSensor.GrayTextColor
        lineChartView.noDataText = NSLocalizedString("no_data_text", comment: "")
        lineChartView.noDataFont = UIFont(name: "Antenna-Light", size: 11)!
        lineChartView.noDataTextColor = (Globals.isAirComfort()) ? TktConstants.Color.AirComfort.PrimaryTextColor : TktConstants.Color.AirSensor.GrayTextColor
        lineChartView.xAxis.setLabelCount(5, force: false)
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.xAxis.axisLineWidth = 2.0
        lineChartView.chartDescription?.text = ""
        lineChartView.xAxis.labelFont = UIFont(name: "Antenna-Light", size: 9)!
        lineChartView.xAxis.granularityEnabled = true
        lineChartView.getAxis(.left).labelFont = UIFont(name: "Antenna-Light", size: 9)!
        lineChartView.getAxis(.left).axisLineWidth = 2.0
        lineChartView.getAxis(.left).granularityEnabled = true
        lineChartView.getAxis(.left).granularity = 1.0
        lineChartView.getAxis(.left).decimals = 0
        lineChartView.rightAxis.enabled = false
        lineChartView.legend.enabled = false
    }
    
    private func clearChartData() {
        self.lineChartView.data = nil
        self.lineChartView.xAxis.valueFormatter = nil
        self.lineChartView.animate(xAxisDuration: 1.0, easingOption: .easeInCubic)
    }
    
    private func displayChartData(datas: [Double]) {
        // Clear LineChart previous data if there is any
        self.lineChartView.data = nil
        self.lineChartView.xAxis.valueFormatter = nil
        self.lineChartView.resetZoom()
        self.lineChartView.fitScreen()
        
        var chartDataEntry: [ChartDataEntry] = [ChartDataEntry]()
        
        for i in 0 ..< airQualityInfoViewModel.yAxisLabels.value.count {
            chartDataEntry.append(ChartDataEntry(x: datas[i], y: airQualityInfoViewModel.yAxisLabels.value[i]))
        }
        
        // Check if Value is less than or equal to Two
        if (airQualityInfoViewModel.yAxisLabels.value.count <= 2) {
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
        
        lineChartView.data = data
        lineChartView.xAxis.valueFormatter = self.xAxisValueFormatter
        lineChartView.xAxis.granularity = 1.0 // Set granularity always to reset xAxis Scale
        
        if (chartSegmentedControl.selectedIndex == 1 || chartSegmentedControl.selectedIndex == 2) {
            // Zoom Chart for '1' == '7 Days' and '2' == 'Monthly' Tabs
            zoomToTwoDays(xMax: lineChartView.highestVisibleX, xMin: lineChartView.lowestVisibleX)
        }
        
        if (data.entryCount < 30) {
            lineChartView.animate(xAxisDuration: 0.5)
        } else {
            lineChartView.animate(xAxisDuration: 1.0, easingOption: .linear)
        }
    }
    
    private func zoomToTwoDays(xMax: Double, xMin: Double) {
        let latest: Date = Date(timeIntervalSince1970: xMax)
        
        let latestTime: TimeInterval = latest.millisecondsSince1970
        let newDate = (calendar.date(byAdding: .hour, value: -48, to: latest))
        
        let dividendTimestamp = newDate?.millisecondsSince1970
        
        let xScale: Double = (latestTime - (xMin * 1000)) / (latestTime - dividendTimestamp!)
        let initialPosition = dividendTimestamp! / 1000
        
        lineChartView.zoom(scaleX: CGFloat(xScale), scaleY: 1.0, x: 0, y: 0)
        lineChartView.moveViewToX(initialPosition)
        
        lineChartView.viewPortHandler.setMinimumScaleX(CGFloat(xScale))
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
    
    private func checkLimitLines() {
        // Clear Limit Lines
        lineChartView.leftAxis.removeAllLimitLines()
        
        if ((airQualityInfoViewModel.upperLimit > 0.0) || (self.dataTypeSegmentedControl.selectedIndex == 0) ||
            (self.dataTypeSegmentedControl.selectedIndex == 1)) {
            upperLimit = ChartLimitLine(limit: airQualityInfoViewModel.upperLimit)
            upperLimit?.lineWidth = 1.5
            upperLimit?.lineColor = UIColor(red: 239, green: 88, blue: 87)
            lineChartView.leftAxis.addLimitLine(upperLimit!)
        }
        
        if ((airQualityInfoViewModel.lowerLimit > 0.0) || (self.dataTypeSegmentedControl.selectedIndex == 0) ||
            (self.dataTypeSegmentedControl.selectedIndex == 1) ) {
            lowerLimit = ChartLimitLine(limit: airQualityInfoViewModel.lowerLimit)
            lowerLimit?.lineWidth = 1.5
            lowerLimit?.lineColor = UIColor(red: 239, green: 88, blue: 87)
            lineChartView.leftAxis.addLimitLine(lowerLimit!)
        }
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
    
    private func assignDecibelLimitLines(address: String) {
        let minDecibelKey = "\(address)\(TktConstants.Key.MinDecibel)"
        let maxDecibelKey = "\(address)\(TktConstants.Key.MaxDecibel)"
        
        decLowerLimit = (preferences.double(forKey: minDecibelKey) == 0.0) ?
            TktConstants.Default.DefaultMinimumDecibel : preferences.double(forKey: minDecibelKey)
        decUpperLimit = (preferences.double(forKey: maxDecibelKey) == 0.0) ?
            TktConstants.Default.DefaultMaximumDecibel : preferences.double(forKey: maxDecibelKey)
    }
    
    private func assignLuxLimitLines(address: String) {
        let minLuxKey = "\(address)\(TktConstants.Key.MinLux)"
        let maxLuxKey = "\(address)\(TktConstants.Key.MaxLux)"

        // We check if the Min Lux Key exist,
        // Because Min Lux can also set 0 value,
        // if we use preferences.double(forKey: minLuxKey), it returns 0.0
        // which is the same for default value. Reason the Ternary operator is
        // not applicable for this instance - Francis 09/11/2017
        if (preferences.object(forKey: minLuxKey) != nil) {
            luxLowerLimit = preferences.double(forKey: minLuxKey)
        } else {
            luxLowerLimit = TktConstants.Default.DefaultMinimumLux
        }
        
        luxUpperLimit = (preferences.double(forKey: maxLuxKey) == 0.0) ?
            TktConstants.Default.DefaultMaximumLux : preferences.double(forKey: maxLuxKey)
    }
    
    private func showActivityIncidator() {
        lineChartView.isHidden = true
        activityIndicator.isHidden = false
    }
    
    private func freezeControls() {
        chartSegmentedControl.isUserInteractionEnabled = !chartSegmentedControl.isUserInteractionEnabled
        dataTypeSegmentedControl.isUserInteractionEnabled = !dataTypeSegmentedControl.isUserInteractionEnabled
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
            
            if (data.sensorUUID == self.airQualityInfoViewModel.sensorData.value?.sensorUUID) {
                
                let isUpdatingSensorUI = self.airQualityInfoViewModel.isUpdatingSensorUI()
                
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
                        self.airQualityInfoViewModel.assignDataSource(indexPath: ip, sensor: data)
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
        airQualityInfoViewModel.generateData(from: from, to: to)
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
        let components = DateComponents(year: selectedYear, month: selectedMonth! + 1)
        if let startOfMonth = calendar.date(from: components) {
            
            var lastDayComponent = DateComponents()
            lastDayComponent.month = 1
            lastDayComponent.day = -1
            let endOfMonth = calendar.date(byAdding: lastDayComponent, to: startOfMonth)
            
            let from = NSNumber(value: startOfMonth.timeIntervalSince1970)
            let to = NSNumber(value: (endOfMonth?.timeIntervalSince1970)!)
            airQualityInfoViewModel.generateData(from: from, to: to)
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
            airQualityInfoViewModel.generateData(from: from, to: to)
        }
    }
    
    @objc private func fromDismissModal(_ notification: Notification) {
        freezeControls()
    }
    
    @objc private func downloadLogsChartRefresh(_ notification: Notification) {
        if (airQualityInfoViewModel.refreshType == TktConstants.Notification.DownloadLogsNotification) {
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
                let currentYear = calendar.component(.year, from: now!)
                let components = DateComponents(year: currentYear, month: selectedMonth! + 1)
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
            
            airQualityInfoViewModel.generateData(from: from!, to: to!)
        }
    }
    
    @objc private func immediateReadChartRefresh(_ notification: Notification) {
        if (airQualityInfoViewModel.refreshType == TktConstants.Notification.DoImmediateReadNotification) {
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
                let currentYear = calendar.component(.year, from: now!)
                let components = DateComponents(year: currentYear, month: selectedMonth! + 1)
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
            
            airQualityInfoViewModel.generateData(from: from!, to: to!)
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
        
        if let oldData = airQualityInfoViewModel.sensorData.value {
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
            
            if let oldName = airQualityInfoViewModel.sensorData.value?.sensorName, let oldPeriod = airQualityInfoViewModel.sensorData.value?.sensorPeriod {
                if (oldName != name || oldPeriod != period) {
                    temporarySensorListCellData = data
                    //temporaryUnit = unit
                    //temporaryOriginalUnit = originalUnit
                    animateRefreshButton()
                }
            }
            
            airQualityInfoViewModel.sensorDataChanged(data: data)
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
        if let st = sensorTemperature.text, let timestamp = airQualityInfoViewModel.vTimeStamp.value {
            if let temp = Float(st.trimmingCharacters(in: TktConstants.CharSet.climateDigits.inverted)), let timestampInt = Int64(timestamp) {
                let maxTemp = Float(tempUpperLimit!)
                let minTemp = Float(tempLowerLimit!)
                let timestampNSNumber = NSNumber(value: timestampInt)
                
                if (temp >= maxTemp) {
                    
                    if (airQualityInfoViewModel.coreDataManager.checkNotificationExist(addressNewsType: "\(address)\(TktConstants.NewsCode.TEMPERATURE_VERY_HIGH)")) {
                        airQualityInfoViewModel.coreDataManager.updateNotification(
                            sensorName: name,
                            addressNewsType: "\(address)\(TktConstants.NewsCode.TEMPERATURE_VERY_HIGH)",
                            timestamp: timestampNSNumber
                        )
                    } else {
                        let newsType = NSNumber(value: TktConstants.NewsCode.TEMPERATURE_VERY_HIGH)
                        
                        NotificationCenter.default.post(name: Notification.Name(rawValue: TktConstants.Notification.AppendAlertNotification), object: nil, userInfo: ["address": address, "name": name, "addressNewsType": "\(address)\(TktConstants.NewsCode.TEMPERATURE_VERY_HIGH)", "timestamp": timestampNSNumber, "newsType": newsType])
                        
                        airQualityInfoViewModel.coreDataManager.saveNotification(
                            macAddress: address,
                            sensorName: name,
                            addressNewsType: "\(address)\(TktConstants.NewsCode.TEMPERATURE_VERY_HIGH)",
                            timestamp: timestampNSNumber,
                            newsType: newsType
                        )
                    }
                    
                } else if (temp <= minTemp) {
                    
                    if (airQualityInfoViewModel.coreDataManager.checkNotificationExist(addressNewsType: "\(address)\(TktConstants.NewsCode.TEMPERATURE_VERY_LOW)")) {
                        airQualityInfoViewModel.coreDataManager.updateNotification(
                            sensorName: name,
                            addressNewsType: "\(address)\(TktConstants.NewsCode.TEMPERATURE_VERY_LOW)",
                            timestamp: timestampNSNumber
                        )
                    } else {
                        let newsType = NSNumber(value: TktConstants.NewsCode.TEMPERATURE_VERY_LOW)
                        
                        NotificationCenter.default.post(name: Notification.Name(rawValue: TktConstants.Notification.AppendAlertNotification), object: nil, userInfo: ["address": address, "name": name, "addressNewsType": "\(address)\(TktConstants.NewsCode.TEMPERATURE_VERY_LOW)", "timestamp": timestampNSNumber, "newsType": newsType])
                        
                        airQualityInfoViewModel.coreDataManager.saveNotification(
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
        if let sh = sensorHumidity.text, let timestamp = airQualityInfoViewModel.vTimeStamp.value {
            if let hum = Float(sh.trimmingCharacters(in: TktConstants.CharSet.climateDigits.inverted)), let timestampInt = Int64(timestamp) {
                let maxHum = Float(humUpperLimit!)
                let minHum = Float(humLowerLimit!)
                let timestampNSNumber = NSNumber(value: timestampInt)
                
                if (hum >= maxHum) {
                    
                    if (airQualityInfoViewModel.coreDataManager.checkNotificationExist(addressNewsType: "\(address)\(TktConstants.NewsCode.HUMIDITY_VERY_HIGH)")) {
                        airQualityInfoViewModel.coreDataManager.updateNotification(
                            sensorName: name,
                            addressNewsType: "\(address)\(TktConstants.NewsCode.HUMIDITY_VERY_HIGH)",
                            timestamp: timestampNSNumber
                        )
                    } else {
                        let newsType = NSNumber(value: TktConstants.NewsCode.HUMIDITY_VERY_HIGH)
                        
                        NotificationCenter.default.post(name: Notification.Name(rawValue: TktConstants.Notification.AppendAlertNotification), object: nil, userInfo: ["address": address, "name": name, "addressNewsType": "\(address)\(TktConstants.NewsCode.HUMIDITY_VERY_HIGH)", "timestamp": timestampNSNumber, "newsType": newsType])
                        
                        airQualityInfoViewModel.coreDataManager.saveNotification(
                            macAddress: address,
                            sensorName: name,
                            addressNewsType: "\(address)\(TktConstants.NewsCode.HUMIDITY_VERY_HIGH)",
                            timestamp: timestampNSNumber,
                            newsType: newsType
                        )
                    }
                    
                } else if (hum <= minHum) {
                    
                    if (airQualityInfoViewModel.coreDataManager.checkNotificationExist(addressNewsType: "\(address)\(TktConstants.NewsCode.HUMIDITY_VERY_LOW)")) {
                        airQualityInfoViewModel.coreDataManager.updateNotification(
                            sensorName: name,
                            addressNewsType: "\(address)\(TktConstants.NewsCode.HUMIDITY_VERY_LOW)",
                            timestamp: timestampNSNumber
                        )
                    } else {
                        let newsType = NSNumber(value: TktConstants.NewsCode.HUMIDITY_VERY_LOW)
                        
                        NotificationCenter.default.post(name: Notification.Name(rawValue: TktConstants.Notification.AppendAlertNotification), object: nil, userInfo: ["address": address, "name": name, "addressNewsType": "\(address)\(TktConstants.NewsCode.HUMIDITY_VERY_LOW)", "timestamp": timestampNSNumber, "newsType": newsType])
                        
                        airQualityInfoViewModel.coreDataManager.saveNotification(
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
    
    @objc private func DecibelRangeChanged(_ notification: Notification) {
        guard let min = notification.userInfo?["min"] as? Int,
            let max = notification.userInfo?["max"] as? Int else {
                Globals.log("Decibel Ranges Invalid")
                
                return
        }
        
        decUpperLimit = Double(max).rounded()
        decLowerLimit = Double(min).rounded()
    }
    
    @objc private func LuxRangeChanged(_ notification: Notification) {
        guard let min = notification.userInfo?["min"] as? Int,
            let max = notification.userInfo?["max"] as? Int else {
                Globals.log("Lux Ranges Invalid")
                
                return
        }
        
        luxUpperLimit = Double(max).rounded()
        luxLowerLimit = Double(min).rounded()
    }
    
    // MARK: Actions
    @IBAction func onIconPressed(_ sender: Any) {
        if (airQualityInfoViewModel.queueManager.sensorDetails.value.count > 0) {
            
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
        
        if (!airQualityInfoViewModel.coreBluetoothManager.isBluetoothPoweredOn) {
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
            
            airQualityInfoViewModel.refreshSensor()
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
        
        let date1 = dateFormatter.string(from: now!)
        let date2 = dateFormatter.string(from: currentDate!)
        
        nextButton.isEnabled = (date1 == date2) ? false : true
        
        let from = NSNumber(value: (currentDate?.startOfDay.timeIntervalSince1970)!)
        let to = NSNumber(value: (currentDate?.endOfDay.timeIntervalSince1970)!)
        airQualityInfoViewModel.generateData(from: from, to: to)
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
            airQualityInfoViewModel.generateData(from: from, to: to)
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
            
            airQualityInfoViewModel.selectedChartTab = TktConstants.Tab.Day
            
            // Generate Today's Data in Chart
            let from = NSNumber(value: (currentDate?.startOfDay.timeIntervalSince1970)!)
            let to = NSNumber(value: (currentDate?.endOfDay.timeIntervalSince1970)!)
            airQualityInfoViewModel.generateData(from: from, to: to)
            
        case 1:
            weeklyLabel.isHidden = false
            
            datePicker.isHidden = true
            previousButton.isHidden = true
            nextButton.isHidden = true
            monthPicker.isHidden = true
            yearPicker.isHidden = true
            
            airQualityInfoViewModel.selectedChartTab = TktConstants.Tab.Weekly
            
            // Generate Weekly Data in Chart
            let from = NSNumber(value: (lastWeekDate?.startOfDay.timeIntervalSince1970)!)
            let to = NSNumber(value: (now?.endOfDay.timeIntervalSince1970)!)
            airQualityInfoViewModel.generateData(from: from, to: to)
            
        case 2:
            monthPicker.isHidden = false
            yearPicker.isHidden = false
            
            datePicker.isHidden = true
            previousButton.isHidden = true
            nextButton.isHidden = true
            weeklyLabel.isHidden = true
            
            airQualityInfoViewModel.selectedChartTab = TktConstants.Tab.Monthly
            
            // Generate Monthly Data in Chart
            let components = DateComponents(year: selectedYear!, month: selectedMonth! + 1)
            if let startOfMonth = calendar.date(from: components) {
                
                var lastDayComponent = DateComponents()
                lastDayComponent.month = 1
                lastDayComponent.day = -1
                let endOfMonth = calendar.date(byAdding: lastDayComponent, to: startOfMonth)
                
                let from = NSNumber(value: startOfMonth.timeIntervalSince1970)
                let to = NSNumber(value: (endOfMonth?.timeIntervalSince1970)!)
                
                airQualityInfoViewModel.generateData(from: from, to: to)
            }
            
        default:
            return
        }
    }
    
    func dataTypeSegmentedValueChanged(_ sender: AnyObject?) {
        
        switch dataTypeSegmentedControl.selectedIndex {
        case 0:
            showActivityIncidator()
            freezeControls()
            airQualityInfoViewModel.attrToFetch = TktConstants.Key.attrTemperature
            
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
            
            airQualityInfoViewModel.generateData(from: from, to: to)
            
        case 1:
            showActivityIncidator()
            freezeControls()
            airQualityInfoViewModel.attrToFetch = TktConstants.Key.attrHumidity
            
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
            
            airQualityInfoViewModel.generateData(from: from, to: to)
            
        case 2:
            showActivityIncidator()
            freezeControls()
            airQualityInfoViewModel.attrToFetch = Globals.isAirComfort() ? TktConstants.Key.attrVOC : TktConstants.Key.attrDecibel
            
            // Generate Today's Humidity Data in Chart
            var from = NSNumber(value: (currentDate?.startOfDay.timeIntervalSince1970)!)
            var to = NSNumber(value: (currentDate?.endOfDay.timeIntervalSince1970)!)
            
            if (chartSegmentedControl.selectedIndex == 1) { // Weekly Tab
                from = NSNumber(value: (lastWeekDate?.startOfDay.timeIntervalSince1970)!)
                to = NSNumber(value: (now?.endOfDay.timeIntervalSince1970)!)
            } else if (chartSegmentedControl.selectedIndex == 2) { // Monthly Tab
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
            
            airQualityInfoViewModel.generateData(from: from, to: to)
            
        case 3:
            showActivityIncidator()
            freezeControls()
            airQualityInfoViewModel.attrToFetch = Globals.isAirComfort() ? TktConstants.Key.attrCO2 : TktConstants.Key.attrLux
            
            // Generate Today's Humidity Data in Chart
            var from = NSNumber(value: (currentDate?.startOfDay.timeIntervalSince1970)!)
            var to = NSNumber(value: (currentDate?.endOfDay.timeIntervalSince1970)!)
            
            if (chartSegmentedControl.selectedIndex == 1) { // Weekly Tab
                from = NSNumber(value: (lastWeekDate?.startOfDay.timeIntervalSince1970)!)
                to = NSNumber(value: (now?.endOfDay.timeIntervalSince1970)!)
            } else if (chartSegmentedControl.selectedIndex == 2) { // Monthly Tab
                
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
            
            airQualityInfoViewModel.generateData(from: from, to: to)
            
        default:
            return
        }
    }
    
    // MARK: CoverflowViewControllerDelegate
    func didFinishPickingMediaWithInfo(_ image: UIImage) {
        DispatchQueue.global(qos: .userInteractive).sync {
            let imageSize = CGSize(width: 500, height: 500)
            let sensorImage = Globals.resizeImage(image, targetSize: imageSize)
            airQualityInfoViewModel.updateSensorPhoto(image: sensorImage)
        }
    }
    
    func didFinishPickingImageInCoverflow(_ image: UIImage, imageCode: Int) {
        var sensorType: String = ""
        
        switch imageCode {
        case 0:
            sensorType = (Globals.isAirComfort()) ? NSLocalizedString("air_quality", comment: "") : TktConstants.AdvertismentName.SomfyAirSensorLocalName_A
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
            airQualityInfoViewModel.updateSensorPhoto(image: sensorImage)
        }
    }
    
    func formatCallingViewNavigation() {
        self.navigationController?.colorNavigationBar()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    // MARK: AirSensorGUI
    private func displayAirSensorView() {
        var backButton = UIImage(named: "back_airsensor")
        backButton = backButton?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.leftBarButtonItem?.image = backButton
        
        var settingsButton = UIImage(named: "settings_airsensor")
        settingsButton = settingsButton?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.rightBarButtonItem?.image = settingsButton
        
        // Format Background for Air Sensor
        self.view.backgroundColor = TktConstants.Color.AirSensor.LightGrayColor
        
        airSensorDataContainer.isHidden = false
        sensorIconContainer.isHidden = true
        dataContainer.isHidden = true
        
        previousButton.setImage(UIImage(named: "previous_item_button_airsensor"), for: .normal)
        previousButton.backgroundColor = TktConstants.Color.Basic.Clear
        nextButton.setImage(UIImage(named: "next_item_button_airsensor"), for: .normal)
        nextButton.backgroundColor = TktConstants.Color.Basic.Clear
        
        // Update previousButtonConstraints
        if let pbHeightConstraint = (previousButton.constraints.filter{ $0.firstAttribute == .height }.first),
            let pbWidthConstraint = (previousButton.constraints.filter{ $0.firstAttribute == .width }.first),
            let nbHeightConstraint = (nextButton.constraints.filter{ $0.firstAttribute == .height}.first),
            let nbWidthConstraint = (nextButton.constraints.filter{ $0.firstAttribute == .width}.first) {
            pbHeightConstraint.constant = 22.0
            pbWidthConstraint.constant = 14.0
            nbHeightConstraint.constant = 22.0
            nbWidthConstraint.constant = 14.0
        }
        
        chartSegmentedControl.titles = [NSLocalizedString("day", comment: ""), NSLocalizedString("week", comment: ""), NSLocalizedString("month", comment: "")]
        chartSegmentedControl.font = UIFont(name: "Antenna-Light", size: 12)!
        chartSegmentedControl.setSelectedTitleColor = TktConstants.Color.AirSensor.GrayTextColor
        chartSegmentedControl.setUnselectedTitleColor = TktConstants.Color.AirSensor.GrayTextColor
        chartSegmentedControl.layoutIfNeeded() // Call this to get the updated value for Autolayout frames in CustomSegmentedControl
        var cscSelectedFrame = chartSegmentedControl.bounds
        var newWidth = cscSelectedFrame.width / CGFloat(chartSegmentedControl.titles.count)
        cscSelectedFrame.size.width = newWidth
        let cscSelectedView = UIView(frame: cscSelectedFrame)
        chartSegmentedControl.setSelectedBackgroundColor = Globals.getImageColor(view: cscSelectedView, image: UIImage(named: "gray_line_bottom")!)
        chartSegmentedControl.setUnselectedBackgroundColor = Globals.getImageColor(view: cscSelectedView, image: UIImage(named: "gray_line_straight_bottom")!)
        
        dataTypeSegmentedControl.titles = ["", "", "", ""] // because we are using images instead of Text
        dataTypeSegmentedControl.itemImages = [
            UIImage(named: "temperature_airsensor_gray")!,
            UIImage(named: "humidity_airsensor_gray")!,
            UIImage(named: "decibel_airsensor_gray")!,
            UIImage(named: "lux_airsensor_gray")!
        ]
        dataTypeSegmentedControl.selectedItemImages = [
            UIImage(named: "temperature_airsensor")!,
            UIImage(named: "humidity_airsensor")!,
            UIImage(named: "decibel_airsensor")!,
            UIImage(named: "lux_airsensor")!
        ]
        dataTypeSegmentedControl.setSelectedTitleColor = TktConstants.Color.AirSensor.GrayTextColor
        dataTypeSegmentedControl.setUnselectedTitleColor = TktConstants.Color.AirSensor.GrayTextColor
        dataTypeSegmentedControl.layoutIfNeeded() // Call this to get the updated value for Autolayout frames in CustomSegmentedControl
        var dtcSelectedFrame = dataTypeSegmentedControl.bounds
        newWidth = dtcSelectedFrame.width / CGFloat(dataTypeSegmentedControl.titles.count)
        dtcSelectedFrame.size.width = newWidth
        let dtcSelectedView = UIView(frame: dtcSelectedFrame)
        dataTypeSegmentedControl.setSelectedBackgroundColor = Globals.getImageColor(view: dtcSelectedView, image: UIImage(named: "gray_line_top")!)
        dataTypeSegmentedControl.setUnselectedBackgroundColor = Globals.getImageColor(view: dtcSelectedView, image: UIImage(named: "gray_line_straight_top")!)
        
        weeklyLabel.textColor = TktConstants.Color.AirSensor.GrayTextColor
        lastUpdatedTimestamp.textColor = TktConstants.Color.AirSensor.GrayTextColor
        refreshButton.setImage(UIImage(named: "refresh_button_airsensor"), for: .normal)
        datePicker.backgroundColor = TktConstants.Color.AirSensor.CustomButtonColor
        monthPicker.backgroundColor = TktConstants.Color.AirSensor.CustomButtonColor
        yearPicker.backgroundColor = TktConstants.Color.AirSensor.CustomButtonColor
    }
}

// MARK: ChartViewDelegate
extension AirQualityInfoViewController: ChartViewDelegate {
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        //Globals.log("Y Value \(entry.y.roundTo(places: 2))")
    }
    
}
