

// Previous Config

    
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
