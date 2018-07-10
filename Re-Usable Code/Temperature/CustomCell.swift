    
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
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
