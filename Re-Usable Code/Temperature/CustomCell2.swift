    
    // MARK: Properties
    @IBOutlet weak var containerTHI: CustomRowView!
    @IBOutlet weak var sensorIconTHI: CustomButton!
    @IBOutlet weak var sensorNameTHI: UILabel!
    @IBOutlet weak var sensorTemperatureTHI: UILabel!
    @IBOutlet weak var sensorTemperatureImageTHI: UIImageView!
    @IBOutlet weak var sensorHumidityTHI: UILabel!
    @IBOutlet weak var sensorHumidityImageTHI: UIImageView!
    @IBOutlet weak var sensorVOCTHI: UILabel!
    @IBOutlet weak var sensorVOCImageTHI: UIImageView!
    @IBOutlet weak var sensorCO2THI: UILabel!
    @IBOutlet weak var sensorCO2ImageTHI: UIImageView!
    @IBOutlet weak var timeStampTHI: UILabel!
    @IBOutlet weak var activityIndicatorTHI: UIActivityIndicatorView!
    
    @IBOutlet weak var bottom_bg_colorTHI: UIView!

    
    
    // MARK: THI @Settings Observer -> placed @didSet
    private func setTHIobservers(address: String) {
        
        let showTHIKey = "\(address)\(TktConstants.Key.ShowSensorTHI)"

        if ((preferences.object(forKey: showTHIKey) != nil) && (preferences.object(forKey: TktConstants.Key.SettingsTHIVisibility) != nil)) {
            let settingsNotifier = preferences.integer(forKey: showTHIKey)
            let debugNotifier = preferences.integer(forKey: TktConstants.Key.SettingsTHIVisibility)
            if ((settingsNotifier == 1) && (debugNotifier == 1)) {
                self.thiContainerEnabler(isHidden: false)
            } else if ((settingsNotifier == 0) && (debugNotifier == 1)) {
                self.thiContainerEnabler(isHidden: true)
            } else {
                self.thiContainerEnabler(isHidden: true)
            }
        }
    }
    
    private func thiContainerEnabler(isHidden: Bool) {
        self.thiStackView.isHidden = isHidden
        self.container.isHidden = !isHidden
        self.sensorIcon.isHidden = !isHidden
        self.sensorName.isHidden = !isHidden
        self.sensorTemperature.isHidden = !isHidden
        self.sensorTemperatureImage.isHidden = !isHidden
        self.sensorHumidity.isHidden = !isHidden
        self.sensorHumidityImage.isHidden = !isHidden
        self.sensorVOC.isHidden = !isHidden
        self.sensorVOCImage.isHidden = !isHidden
        self.sensorCO2.isHidden = !isHidden
        self.sensorCO2Image.isHidden = !isHidden
        self.timeStamp.isHidden = !isHidden
        self.activityIndicator.isHidden = !isHidden
        self.bottom_bg_color.isHidden = !isHidden
    }
    
    private func setUpDefaultViewElements(data: SensorListCellData) {
        guard let data = self.sensorData else {
            return
        }
        
        self.sensorName.text = data.sensorName
        self.sensorIcon.setImage(data.sensorIcon, for: .normal)
        self.sensorIcon.imageView?.contentMode = .scaleAspectFill
        self.sensorIcon.cornerRadius = 25.0
        
        self.sensorTemperatureImage.image = Globals.getIconImage(view: TktConstants.CallingView.SensorListViewController, preferences: self.preferences,
                                                                 value: data.sensorTemperature!, dataType: TktConstants.Key.attrTemperature, address: data.sensorMacAddress!)
        self.sensorTemperature.text = Globals.getDataText(preferences: self.preferences, data: data.sensorTemperature!, isTemperature: true)
        self.sensorTemperature.textColor = Globals.getTemperatureTextColor(view: TktConstants.CallingView.SensorListViewController, preferences: self.preferences, temperature: data.sensorTemperature, address: data.sensorMacAddress!)
        
        self.sensorHumidityImage.image = Globals.getIconImage(view: TktConstants.CallingView.SensorListViewController, preferences: self.preferences,
                                                              value: data.sensorHumidity!, dataType: TktConstants.Key.attrHumidity, address: data.sensorMacAddress!)
        self.sensorHumidity.text = Globals.getDataText(preferences: self.preferences, data: data.sensorHumidity!, isTemperature: false)
        self.sensorHumidity.textColor = Globals.getHumidityTextColor(view: TktConstants.CallingView.SensorListViewController, preferences: self.preferences, humidity: data.sensorHumidity!, address: data.sensorMacAddress!)
        
        if let lastUpdatedTimestamp = Double(data.sensorLastUpdated) {
            self.timeStamp.isHidden = (lastUpdatedTimestamp != 0.0) ? false : true
            self.setReferenceTime(referenceTime: lastUpdatedTimestamp)
        }
        
        // VOC and CO2
        if let voc = Double(data.sensorVOC.trimmingCharacters(in: TktConstants.CharSet.climateDigits.inverted)),
            let co2 = Double(data.sensorCO2.trimmingCharacters(in: TktConstants.CharSet.climateDigits.inverted)) {
            
            self.sensorVOCImage.image = Globals.getIconImage(view: TktConstants.CallingView.SensorListViewController, preferences: self.preferences,
                                                             value: data.sensorVOC!, dataType: TktConstants.Key.attrVOC, address: data.sensorMacAddress!)
            self.sensorVOC.textColor = (((voc > TktConstants.Default.VOC_THRESHOLD_MAX) || (voc <= 0.0))) ? TktConstants.Color.AirComfort.WarningTextColor : TktConstants.Color.AirComfort.SwitchOnColor
            self.sensorVOC.text = (co2 == TktConstants.QualityLevels.Invalid) ? "" : data.sensorVOC
            
            self.sensorCO2Image.image = Globals.getIconImage(view: TktConstants.CallingView.SensorListViewController, preferences: self.preferences,
                                                             value: data.sensorCO2!, dataType: TktConstants.Key.attrCO2, address: data.sensorMacAddress!)
            self.sensorCO2.textColor = (co2 > TktConstants.Default.CO2_THRESHOLD_MAX) ? TktConstants.Color.AirComfort.WarningTextColor :  TktConstants.Color.AirComfort.SwitchOnColor
            self.sensorCO2.text = (co2 == TktConstants.QualityLevels.Invalid) ? "" : data.sensorCO2
        } else {
            // We are downloading a new Peripheral, this clear the image and the text of VOC and CO2
            self.sensorVOCImage.image = nil
            self.sensorVOC.text = ""
            self.sensorCO2Image.image = nil
            self.sensorCO2.text = ""
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
