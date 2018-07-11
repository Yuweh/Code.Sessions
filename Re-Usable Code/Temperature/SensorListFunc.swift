
//SensorList VC -> CGFloat

   height = self.sensorMainViewModel.setTHIobservers(address: data.sensorMacAddress, view: TktConstants.CallingView.AirComfortInfoViewController) //128.0 //88.0


// SensorList VM Func

    // MARK: THI @Settings Observer -> placed @didSet
    public func setTHIobservers(address: String, view: String) -> CGFloat {
        
        let showTHIKey = "\(address)\(TktConstants.Key.ShowSensorTHI)"
        
        if ((preferences.object(forKey: showTHIKey) != nil) && (preferences.object(forKey: TktConstants.Key.SettingsTHIVisibility) != nil)) {
            let settingsNotifier = preferences.integer(forKey: showTHIKey)
            let debugNotifier = preferences.integer(forKey: TktConstants.Key.SettingsTHIVisibility)
            if ((settingsNotifier == 1) && (debugNotifier == 1)) {
                return self.cellHeightEnabler(enabledTHI: true, view: view)
            } else if ((settingsNotifier == 0) && (debugNotifier == 1)) {
                return self.cellHeightEnabler(enabledTHI: false, view: view)
            } else {
                return self.cellHeightEnabler(enabledTHI: false, view: view)
            }
        }
        return 128.0
    }
    
    public func cellHeightEnabler(enabledTHI: Bool, view: String) -> CGFloat {
        if (enabledTHI) {
            switch view {
            case TktConstants.CallingView.AirComfortInfoViewController:
                return 128.0
            case TktConstants.CallingView.AirQualityInfoViewController:
                return 165.0
            default:
                return 128.0
            }
        } else {
            switch view {
            case TktConstants.CallingView.AirComfortInfoViewController:
                return 88.0
            case TktConstants.CallingView.AirQualityInfoViewController:
                return 128.0
            default:
                return 128.0
            }
        }
    }
