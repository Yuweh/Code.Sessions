
//Shared Instance

//TKT
static let isCustomSensorImage = "-customSensorImage"

// MARK: THI Method for Settings
    public func showHideTHIEnabled() -> Bool {
        
        if preferences.object(forKey: TktConstants.Key.SettingsTHIVisibility) != nil {
            let settings = preferences.integer(forKey: TktConstants.Key.SettingsTHIVisibility)
            if (settings == 1) {
                preferences.set(0, forKey: TktConstants.Key.SettingsTHIVisibility)
                preferences.synchronize()
                
                return false
            }
        }
        
        preferences.set(1, forKey: TktConstants.Key.SettingsTHIVisibility)
        preferences.synchronize()
        
        return true
    }


    // MARK: CoverflowViewControllerDelegate

//didFinishPickingMediaWithInfo(_ image: UIImage)

        
        if let address = sensorData?.sensorMacAddress {
            // to allow custom Room Label if custom Sensor Image
            let customImageKey = "\(address)\(TktConstants.Key.isCustomSensorImage)"
            preferences.set(1, forKey: customImageKey)
            
            preferences.synchronize()
        }
        
//didFinishPickingImageInCoverflow(_ image: UIImage, imageCode: Int)

        if let address = sensorData?.sensorMacAddress {
            let roomTypeKey: String = "\(address)\(TktConstants.Key.roomType)"
            preferences.set(sensorType, forKey: roomTypeKey)
            
            // to allow custom Room Label if custom Sensor Image
            let customImageKey = "\(address)\(TktConstants.Key.isCustomSensorImage)"
            preferences.set(0, forKey: customImageKey)
            
            preferences.synchronize()
        }

//InfoViewController: 
    func sensorIconSetter(_ address: String, _ value: String) {
        let customImageKey = "\(address)\(TktConstants.Key.isCustomSensorImage)"
        let iconPreference = preferences.integer(forKey: customImageKey)
        
        if (iconPreference == 1) {
            return
        } else if (iconPreference == 0) {
            
            switch value {
            case TktConstants.AdvertismentName.AirComfort:
                sensorIcon.setImage(#imageLiteral(resourceName: "new"), for: .normal)
            case TktConstants.RoomTypes.AirComfort:
                let image = (Globals.isAirComfort()) ? #imageLiteral(resourceName: "new") : #imageLiteral(resourceName: "air_sensor")
                sensorIcon.setImage(image, for: .normal)
            case TktConstants.AdvertismentName.SomfyAirSensorLocalName_A,
                 TktConstants.RoomTypes.EnvironmentComfort:
                sensorIcon.setImage(#imageLiteral(resourceName: "environment_comfort"), for: .normal)
            case TktConstants.AdvertismentName.AirQuality,
                 TktConstants.RoomTypes.AirQuality:
                sensorIcon.setImage(#imageLiteral(resourceName: "air_quality"), for: .normal)
            case TktConstants.RoomTypes.BabyRoom:
                sensorIcon.setImage(#imageLiteral(resourceName: "baby"), for: .normal)
            case TktConstants.RoomTypes.BedRoom:
                sensorIcon.setImage(#imageLiteral(resourceName: "bedroom"), for: .normal)
            case TktConstants.RoomTypes.DiningRoom:
                sensorIcon.setImage(#imageLiteral(resourceName: "dining"), for: .normal)
            case TktConstants.RoomTypes.Kitchen:
                sensorIcon.setImage(#imageLiteral(resourceName: "kitchen"), for: .normal)
            case TktConstants.RoomTypes.LivingRoom:
                sensorIcon.setImage(#imageLiteral(resourceName: "living"), for: .normal)
            case TktConstants.RoomTypes.Toilet:
                sensorIcon.setImage(#imageLiteral(resourceName: "toilet"), for: .normal)
            default:
                return
            }
            
            isPhotoEdited = true
            checkIsPhotoEdited()
        }
        
    }


