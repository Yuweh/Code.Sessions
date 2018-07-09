
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



// MARK: THI Setter
































