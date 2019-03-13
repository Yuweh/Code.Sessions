
    //MARK: TimeStamp Generator and Checker
    func generateCurrentTimeStamp () -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return (formatter.string(from: Date()) as NSString) as String
    }
    
    func saveCurrentTimeStamp(forKey: String) {
        let currentTimeStamp = self.generateCurrentTimeStamp()
        UserDefaults.standard.set(currentTimeStamp, forKey: forKey)
        UserDefaults.standard.synchronize()
    }
    
    func checkGrowingProfileTimeStamp() -> String {
        if preferences.object(forKey: TktConstants.Key.GrowingProfileTimeStamp) != nil {
            let savedTimeStamp: String = UserDefaults.standard.object(forKey: TktConstants.Key.GrowingProfileTimeStamp) as! String
            return savedTimeStamp
        }
        
        self.saveCurrentTimeStamp(forKey: TktConstants.Key.GrowingProfileTimeStamp)
        return self.generateCurrentTimeStamp()
    }
    
   func compareTimeStamp(currentTimeStamp: String, savedTimeStamp: String, minutesToBeAdded: Double) -> Bool {
        let saveTimeStamp: String = savedTimeStamp
        let dateFormatter: DateFormatter = DateFormatter()
        let minutesToAdd: Double = minutesToBeAdded
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateSaved = dateFormatter.date(from: saveTimeStamp)
        let dateNow = dateFormatter.date(from: currentTimeStamp)!
        let minutesToCompare = dateSaved?.addingTimeInterval(minutesToAdd * 60)
        
        if (minutesToCompare! >= dateNow) {
            return true
        }
        return false
    }
