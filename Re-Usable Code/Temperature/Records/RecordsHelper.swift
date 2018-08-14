
//

import Foundation
import UIKit

class RecordsHelper {
    
    let preferences = UserDefaults.standard
    
    static func recordSetter(_ value: Float, _ arrayGroup: [Double], _ unitGroup: String, _ preferences: UserDefaults) {
        var targetArray = arrayGroup
        if (preferences.object(forKey: TktConstants.Key.SettingsInvalidRecordsVisibility) != nil) {
            let recordSettings = preferences.integer(forKey: TktConstants.Key.SettingsInvalidRecordsVisibility)
            if (recordSettings == 1) {
                targetArray.append(Double(value))
            }
            
            recordValidator(value, targetArray, unitGroup, preferences)
        }
    }

    static func recordValidator(_ value: Float, _ arrayGroup: [Double], _ unitGroup: String, _ preferences: UserDefaults) {
        var targetArray = arrayGroup
        
        switch unitGroup {
        case TktConstants.Key.attrTemperature:
            
            if (preferences.object(forKey: TktConstants.Key.UnitPreference) != nil) {
                let unit = preferences.integer(forKey: TktConstants.Key.UnitPreference)
                
                if (unit == 1) {
                    if value <= -13 || value >= 158 {
                        return
                    } else {
                        targetArray.append(Double(value))
                    }
                }
                
                if value <= -25 || value >= 70 {
                    return
                } else {
                    targetArray.append(Double(value))
                }
            }
            
        case TktConstants.Key.attrHumidity:
            if value <= 0 || value >= 100 {
                return
            } else {
                targetArray.append(Double(value))
            }
        case TktConstants.Key.attrVOC:
            if value <= 125 || value >= 600 {
                return
            } else {
                targetArray.append(Double(value))
            }
        case TktConstants.Key.attrCO2:
            if value <= 450 || value >= 2000 {
                return
            } else {
                targetArray.append(Double(value))
            }
        default:
            return
        }
    }
    
    
        
    static func tempHumDataValidator(temp: Float, hum: Float, preferences: UserDefaults) {
        
        if (preferences.object(forKey: TktConstants.Key.SettingsInvalidRecordsVisibility) != nil) {
            let recordSettings = preferences.integer(forKey: TktConstants.Key.SettingsInvalidRecordsVisibility)
            if (recordSettings != 1) {
                if temp <= -25 || temp >= 70 {
                    return
                }
                
                if hum <= 0 || hum >= 90 {
                    return
                }
            }
        }
    }
    
    static func vocCO2DataValidator(voc: Float, co2: Float, preferences: UserDefaults) {
        
        if (preferences.object(forKey: TktConstants.Key.SettingsInvalidRecordsVisibility) != nil) {
            let recordSettings = preferences.integer(forKey: TktConstants.Key.SettingsInvalidRecordsVisibility)
            if (recordSettings != 1) {
                if voc <= 125 || voc >= 600  {
                    return
                }
                
                if co2 <= 450 || co2 >= 2000 {
                    return
                }
            }
        }
    }
    
}
