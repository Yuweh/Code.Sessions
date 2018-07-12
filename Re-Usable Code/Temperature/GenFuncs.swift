

// Instance member 'preferences' cannot be used on type 'Globals'
    
    static func setTHICellElements(data: sensorListCellData, unit: Int, thiImage: UIImageView, thiLabel: UILabel){
            let tempValue = Float(data.sensorTemperature.trimmingCharacters(in: TktConstants.CharSet.climateDigits.inverted))!
            let humValue = Float(data.sensorHumidity.trimmingCharacters(in: TktConstants.CharSet.climateDigits.inverted))!
            let thiValue = "\(Globals.computeTHIValue(value: tempValue, humidity: humValue, unit: unit))"
            thiImage.image = Globals.getIconImage(view: TktConstants.CallingView.SensorListViewController, preferences: self.preferences, value: thiValue, dataType: TktConstants.Key.attrTHI, address: data.sensorMacAddress!)
            thiLabel.textColor = Globals.getTHITextColor(view: TktConstants.CallingView.AirComfortInfoViewController, preferences: self.preferences, thiValue: thiValue, address: data.sensorMacAddress!)
            thiLabel.text = Globals.getTHIText(preferences: self.preferences, data: thiValue)

    }
