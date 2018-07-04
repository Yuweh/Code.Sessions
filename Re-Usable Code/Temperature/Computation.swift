
// THI Computation

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
    private func setTHIobservers() {
        
        //
        _ = debugViewController.vTHIEnabled.asObservable().subscribe { value in
            if let element = value.element {
                print("\(element) THI Value computed - now ready for testing  *** ")
            }
        }
    }



































