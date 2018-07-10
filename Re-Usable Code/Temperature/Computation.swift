
// THI Computation

            // Main
                static func computeTHI(celcius: Float, humidity: Float) -> Float {
            let thiValue: Float = (1.8 * celcius + 32) - ((0.55 - 0.0055 * humidity) * (1.8 * celcius - 26))
        return thiValue
    }

            // MARK: THI Method
            if let tempValue = Float(sensor.sensorTemperature.trimmingCharacters(in: TktConstants.CharSet.climateDigits.inverted)),
                let humValue = Float(sensor.sensorTemperature.trimmingCharacters(in: TktConstants.CharSet.climateDigits.inverted)) {
                
                vSensorTHI.value = "\(Globals.computeTHI(celcius: tempValue, humidity: humValue))"
            }



        // MARK: THI Observer for Outlet
        _ = airComfortInfoViewModel.vSensorTHI.asObservable().subscribe { value in
            if let element = value.element {
                print("\(element) THI Value computed - now ready for testing  *** ")
            }
        }

    // MARK: TKT Constants for THI
        static let SettingsTHIVisibility = "SettingsTHIVisibility"
        static let SettingsHorticultureVisibility = "SettingsHorticultureVisibility" //OnHOLD
        static let SensorMainTHIVisibility = "SensorMainTHIVisibility" //OnHOLD
        static let SensorMainHorticultureVisibility = "SensorMainHorticultureVisibility" //OnHOLD

    // MARK: THI Observer
    private func setTHIobservers() {
        
        // From Debug's THI Notifier
        if preferences.object(forKey: TktConstants.Key.SettingsTHIVisibility) != nil {
            let settings = preferences.integer(forKey: TktConstants.Key.SettingsTHIVisibility)
            if settings == 1 {
                print(" Settings THI READY for further development")
                //set switches here
                self.tempHumContainer.isHidden = true
                self.thiContainer.isHidden = false
            } else if settings == 0 {
                print("Settings THI Disabled yet ready for further development")
                //set switches here
                self.tempHumContainer.isHidden = false
                self.thiContainer.isHidden = true
            }
        }
        
        // From Debug's Horticulture Notifier
        if preferences.object(forKey: TktConstants.Key.SettingsHorticultureVisibility) != nil {
            let settings = preferences.integer(forKey: TktConstants.Key.SettingsHorticultureVisibility)
            if settings == 1 {
                print("Horticulture READY for further development")
                //set switches here
            } else if settings == 0 {
                print("Horticulture Disabled yet ready for further development")
                //set switches here
            }
        }
    }



    // MARK: getTHIText
    
    static func getTHIText(preferences: UserDefaults, data: String) -> String {
        
        if let rawData = Double(data.trimmingCharacters(in: TktConstants.CharSet.climateDigits.inverted)) {
            if (rawData >= 15){ // Check if IM read returns zero value
                return "\(String(format: "%.1f", rawData))\(TktConstants.Units.THI)"
            }
        }
        return ""
    }


    //MARK: GetTHITextColor
    static func getTHITextColor(view: String, preferences: UserDefaults, thiValue: String, address: String) -> UIColor {
        
        if let thiValue = Double(thiValue.trimmingCharacters(in: TktConstants.CharSet.climateDigits.inverted)) {
            if (view == TktConstants.CallingView.SensorListViewController) {
                return (thiValue >= TktConstants.Default.THI_THRESHOLD_MAX) ? TktConstants.Color.Basic.White : TktConstants.Color.Basic.White
            }
            if thiValue >= TktConstants.Default.THI_THRESHOLD_MAX {
                return TktConstants.Color.AirComfort.WarningTextColor
            } else if ((thiValue >= TktConstants.Default.THI_MODERATE_MIN) && (thiValue <= TktConstants.Default.THI_MODERATE_MAX)) {
                return TktConstants.Color.Basic.Orange
            } else if thiValue <= TktConstants.Default.THI_THRESHOLD_MIN {
                return TktConstants.Color.Basic.White
            }
        }
        
        return TktConstants.Color.Basic.Clear
    }

        // MARK: THI Get IconImage
        case TktConstants.Key.attrTHI:
            if let thi = Double(value.trimmingCharacters(in: TktConstants.CharSet.climateDigits.inverted)) {
                if (view == TktConstants.CallingView.SensorListViewController) {
                    return (thi >= TktConstants.Default.THI_THRESHOLD_MAX) ? UIImage(named: "thi_Red")! : UIImage(named: "thi_White")!
                }
                if thi >= TktConstants.Default.THI_THRESHOLD_MAX {
                    return UIImage(named: "thi_Red")!
                } else if thi >= TktConstants.Default.THI_MODERATE_MIN {
                    return UIImage(named: "thi_Orange")!
                } else if thi <= TktConstants.Default.THI_THRESHOLD_MIN {
                    return UIImage(named: "thi_White")!
                } else if thi <= 15.0 {
                    return UIImage(named: "thi_Red")!
                }
            }

        //THI InfoPage Values
        static let THI_THRESHOLD_MIN: Double = 67.0 //67 below = White
        static let THI_THRESHOLD_MAX: Double = 75.0 //75 = Red
        static let THI_MODERATE_MIN: Double = 68.0  //
        static let THI_MODERATE_MAX: Double = 74.0




    // MARK: THI @Settings Observer
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
        self.defaultStackView.isHidden = !isHidden
    }

    private func thiContainerEnabler(isHidden: Bool) {
            self.thiTopStackView.isHidden = isHidden
            self.thiBottomStackView.isHidden = isHidden
            self.rightDefaulStackView.isHidden = !isHidden
            self.leftDefaulStackView.isHidden = !isHidden
    }





















