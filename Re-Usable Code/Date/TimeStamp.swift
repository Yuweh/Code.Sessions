
    //MARK: TimeStamp: allowed for less than 15 mins.
    
    @objc static func generateCurrentTimeStamp () -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return (formatter.string(from: Date()) as NSString) as String
    }
    
    @objc static func generateFifteenMinTimeStamp () -> String {
        let savedTimeStamp = UserDefaults.standard.string(forKey: "-timestamp")
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let datecomponents = dateFormatter.date(from: savedTimeStamp!)!
        let minutes: Double = 15
        let time = datecomponents.addingTimeInterval(minutes * 60)
        return (dateFormatter.string(from: time) as NSString) as String
    }
    
    
    @objc static func saveCurrentTimeStamp() {
        let currentTimeStamp = self.generateCurrentTimeStamp()
            UserDefaults.standard.set(currentTimeStamp, forKey: "-timestamp")
            UserDefaults.standard.synchronize()
    }
    
    @objc static func timeStampMoreThanFifteenMin(date: String) -> Bool {
        let dateFormatter: DateFormatter = DateFormatter()
        let minutesToAdd: Double = 15
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateSaved = dateFormatter.date(from: date)!
        let minutesToCompare = dateSaved.addingTimeInterval(minutesToAdd * 60)
        
        if (dateSaved >= minutesToCompare) {
            return true
        } else {
            return false
        }
    }
    
    @objc static func checkCurrentTimeStamp() -> Bool {
        
        if UserDefaults.standard.object(forKey: "-timestamp") != nil {
            let savedToken = UserDefaults.standard.string(forKey: "-timestamp")
            
            
            return true
        }
        return false
    }





