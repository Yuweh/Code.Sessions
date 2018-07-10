    
    // MARK: Properties
    @IBOutlet weak var thiStackView: UIView!
    @IBOutlet weak var containerTHI: CustomRowView!
    @IBOutlet weak var sensorIconTHI: CustomButton!
    @IBOutlet weak var sensorNameTHI: UILabel!
    @IBOutlet weak var sensorTemperatureTHI: UILabel!
    @IBOutlet weak var sensorTemperatureImageTHI: UIImageView!
    @IBOutlet weak var sensorHumidityTHI: UILabel!
    @IBOutlet weak var sensorHumidityImageTHI: UIImageView!
    @IBOutlet weak var timeStampTHI: UILabel!
    @IBOutlet weak var activityIndicatorTHI: UIActivityIndicatorView!

    
    
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
        self.sensorIcon.isHidden = !isHidden
        self.sensorName.isHidden = !isHidden
        self.sensorTemperature.isHidden = !isHidden
        self.sensorTemperatureImage.isHidden = !isHidden
        self.sensorHumidity.isHidden = !isHidden
        self.sensorHumidityImage.isHidden = !isHidden
        self.timeStamp.isHidden = !isHidden
        self.activityIndicator.isHidden = !isHidden
    }
    

    private func setUpDefaultViewElements(data: SensorListCellData) {
        
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
    }
        
        private func setUpTHIViewElements(data: SensorListCellData) {
        
        self.sensorNameTHI.text = data.sensorName
        self.sensorIconTHI.setImage(data.sensorIcon, for: .normal)
        self.sensorIconTHI.imageView?.contentMode = .scaleAspectFill
        self.sensorIconTHI.cornerRadius = 25.0
        
        self.sensorTemperatureImageTHI.image = Globals.getIconImage(view: TktConstants.CallingView.SensorListViewController, preferences: self.preferences,
                                                                 value: data.sensorTemperature!, dataType: TktConstants.Key.attrTemperature, address: data.sensorMacAddress!)
        self.sensorTemperatureTHI.text = Globals.getDataText(preferences: self.preferences, data: data.sensorTemperature!, isTemperature: true)
        self.sensorTemperatureTHI.textColor = Globals.getTemperatureTextColor(view: TktConstants.CallingView.SensorListViewController, preferences: self.preferences, temperature: data.sensorTemperature, address: data.sensorMacAddress!)
        
        self.sensorHumidityImageTHI.image = Globals.getIconImage(view: TktConstants.CallingView.SensorListViewController, preferences: self.preferences,
                                                              value: data.sensorHumidity!, dataType: TktConstants.Key.attrHumidity, address: data.sensorMacAddress!)
        self.sensorHumidityTHI.text = Globals.getDataText(preferences: self.preferences, data: data.sensorHumidity!, isTemperature: false)
        self.sensorHumidityTHI.textColor = Globals.getHumidityTextColor(view: TktConstants.CallingView.SensorListViewController, preferences: self.preferences, humidity: data.sensorHumidity!, address: data.sensorMacAddress!)
        
        if let lastUpdatedTimestamp = Double(data.sensorLastUpdated) {
            self.timeStampTHI.isHidden = (lastUpdatedTimestamp != 0.0) ? false : true
            self.setReferenceTime(referenceTime: lastUpdatedTimestamp)
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
