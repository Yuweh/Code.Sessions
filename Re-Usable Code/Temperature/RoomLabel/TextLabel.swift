
//didFinishPickingImageInCoverflow(image, imageCode) {
        default:
            if  let sensor = sensorData {
                sensorType.text = infoViewModel.setRoomTypeLabel(roomType: sensor.sensorType, macAddress: sensor.sensorMacAddress)
            }
            
//setRoomTypeLabel(roomType: String, macAddress: String) -> String
            default:
            if (Globals.isAirComfort()) {
                return NSLocalizedString("air_quality", comment: "")
            } else {
                return NSLocalizedString("air_comfort", comment: "")
            }
            
            
            
            
            
            
            
            
            
            
