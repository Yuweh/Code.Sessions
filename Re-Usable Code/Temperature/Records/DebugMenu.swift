// VM

    // MARK: Invalid Records Visibility for Settings -SettingsInvalidRecordsVisibility
    public func showHideInvalidRecords() -> Bool {
        
        if preferences.object(forKey: TktConstants.Key.SettingsInvalidRecordsVisibility) != nil {
            let settings = preferences.integer(forKey: TktConstants.Key.SettingsInvalidRecordsVisibility)
            if (settings == 1) {
                preferences.set(0, forKey: TktConstants.Key.SettingsInvalidRecordsVisibility)
                preferences.synchronize()
                
                return false
            }
        }
        
        preferences.set(1, forKey: TktConstants.Key.SettingsInvalidRecordsVisibility)
        preferences.synchronize()
        
        return true
    }

// VC

     // MARK: Invalid Records Visibility for Settings
    private func setRecordsVisibility() {
        
        if preferences.object(forKey: TktConstants.Key.SettingsInvalidRecordsVisibility) != nil {
            let settings = preferences.integer(forKey: TktConstants.Key.SettingsInvalidRecordsVisibility)
            if settings == 1 {
                self.showHideInvalidRecords.setTitle("Show Invalid Records", for: .normal)
            } else if settings == 0 {
                self.showHideInvalidRecords.setTitle("Hide Invalid Records", for: .normal)
            }
        }
        
    }
    
    // MARK: THI Debug Button Notifier
    @IBAction func recordsBtnPressed(_ sender: UIButton) {
        let thiSettings = debugViewModel.showHideInvalidRecords()
        
        if (thiSettings) {
            self.showHideInvalidRecords.setTitle("Show Invalid Records", for: .normal)
        } else {
            self.showHideInvalidRecords.setTitle("Hide Invalid Records", for: .normal)
        }
    }


//TKTConstants
        static let SettingsInvalidRecordsVisibility = "SettingsInvalidRecordsVisibility"
