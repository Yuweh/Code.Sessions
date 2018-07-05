
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



// MARK: THI Observer

        if preferences.object(forKey: TktConstants.Key.DebugButtonVisibility) != nil {
            let settings = preferences.integer(forKey: TktConstants.Key.DebugButtonVisibility)
            
            debug.isHidden = (settings == 1) ? false : true
        }



// MARK: THI Setter


            debug.isHidden = false
            preferences.set(1, forKey: TktConstants.Key.DebugButtonVisibility)
            preferences.synchronize()






























