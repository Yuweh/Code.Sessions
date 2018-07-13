//
//  ThiHelper.swift
//  AirComfort
//
//  Created by Jay Bergonia on 13/7/2018.
//  
//

import Foundation
import UIKit

class ThiHelper {
    
    // MARK: compute THI Value
    static func computeTHIValue(value: Float, humidity: Float, unit: Int) -> Float {
        if (unit == 1) {
            // Fahrenheit
            let thiValue: Float = (value - (0.55 - (0.55 * humidity/100)) * (value - 58))
            return thiValue
        } else {
            // Celcius
            let convertedValue = Globals.temperature2Fahrenheit(celsius: value)
            let thiValue: Float = (convertedValue - (0.55 - (0.55 * humidity/100)) * (convertedValue - 58))
            return thiValue
        }
    }
    
    // MARK: getTHIText
    static func getTHIText(preferences: UserDefaults, data: String) -> String {
        
        if let rawData = Double(data.trimmingCharacters(in: TktConstants.CharSet.climateDigits.inverted)) {
            if (rawData >= 15.0){ // Check if IM read returns zero value
                return "\(String(format: "%.1f", rawData))\(TktConstants.Units.THI)"
            }
        }
        return ""
    }
    
    // MARK: GetTHITextColor
    static func getTHITextColor(view: String, preferences: UserDefaults, thiValue: String, address: String) -> UIColor {
        
        if let thiValue = Double(thiValue.trimmingCharacters(in: TktConstants.CharSet.climateDigits.inverted)) {
            if (view == TktConstants.CallingView.SensorListViewController) {
                return (thiValue >= TktConstants.Default.THI_THRESHOLD_MAX) ? TktConstants.Color.Basic.White : TktConstants.Color.Basic.White
            }
            if thiValue >= TktConstants.Default.THI_THRESHOLD_MAX {
                return TktConstants.Color.AirComfort.WarningTextColor
            } else if thiValue >= TktConstants.Default.THI_MODERATE_MIN {
                return TktConstants.Color.Basic.Orange
            }  else if thiValue <= 15.0 {
                return TktConstants.Color.AirComfort.WarningTextColor
            } else {
                if (view == TktConstants.CallingView.SensorListViewController) {
                    return TktConstants.Color.AirComfort.SwitchOnColor
                }
                return TktConstants.Color.Basic.White
            }
        }
        
        return TktConstants.Color.Basic.Clear
    }
    
    // MARK: set THI Cell/Thumbnail Image & Text setter
    static func setTHICellElements(data: sensorListCellData, preferences: UserDefaults, thiImage: UIImageView, thiLabel: UILabel){
        let unit = preferences.integer(forKey: TktConstants.Key.UnitPreference)
        let tempValue = Float(data.sensorTemperature.trimmingCharacters(in: TktConstants.CharSet.climateDigits.inverted))!
        let humValue = Float(data.sensorHumidity.trimmingCharacters(in: TktConstants.CharSet.climateDigits.inverted))!
        let thiValue = "\(ThiHelper.computeTHIValue(value: tempValue, humidity: humValue, unit: unit))"
        thiImage.image = Globals.getIconImage(view: TktConstants.CallingView.SensorListViewController, preferences: preferences, value: thiValue, dataType: TktConstants.Key.attrTHI, address: data.sensorMacAddress!)
        thiLabel.textColor = ThiHelper.getTHITextColor(view: TktConstants.CallingView.AirComfortInfoViewController, preferences: preferences, thiValue: thiValue, address: data.sensorMacAddress!)
        thiLabel.text = ThiHelper.getTHIText(preferences: preferences, data: thiValue)
    }
    
    
}
