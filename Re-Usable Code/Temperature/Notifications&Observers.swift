
 
 // Notif keys
 
"showTHI": oldTHISwitch  // for POST
let showTHI = notification.userInfo?["showTHI"] as? NSNumber


    // VM func

 // Add NotificationCenter Observer for SensorDataChangedNotification
        NotificationCenter.default.addObserver(self, selector: #selector(AirComfortInfoViewController.sensorDataChanged(_:)), name: NSNotification.Name(rawValue: TktConstants.Notification.SensorDataChangedNotification), object: nil)

//

//InfoVC NOTIF
       NotificationCenter.default.post(name:Notification.Name(rawValue: TktConstants.Notification.SensorDataChangedNotification), object: nil, userInfo: ["icon": oldSensorIcon!, "name": oldSensorName!, "room_type": st, "period": oldPeriod])















  // preferences w/ showTHIKey
 
            // MARK: thiShowSwitch Comparable Variable
            let oldTHISwitch = (thiShowSwitch.isOn() == true) ?  1 : 0
 
            // MARK: thiShowSwitch OBSERVER
            if preferences.object(forKey: showTHIkey) != nil {
                let isOn = preferences.integer(forKey: showTHIkey)
                showTHIState = isOn
                thiShowSwitch.setOn(showTHIState == 1, animated: false)
            }

            // MARK thisShowSwitch POST
            if (oldTHISwitch != showTHIState) {
                let showTHIKey = "\(address)\(TktConstants.Key.ShowSensorTHI)"
                showTHIState = (showTHIState == 1 ? 0 : 1)
                preferences.set(showTHIState, forKey: showTHIKey)
            }
          
          















