   
    // Google Web API received here
    public func getNearbyLocationsWithLocation(location: CLLocation) {
        //modification "insterted"
        let urlString : String = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=" .  INSER YOUR API KEY HERE "&location="
        let latitude:String = "\(location.coordinate.latitude)"
        let longitude:String = "\(location.coordinate.longitude)"
        let radius = String(regionRadius)
        let keyword = String("atm")
        let firstString = urlString + latitude + "," + longitude
        let secondString = "&radius=" + radius + "&keyword=" + keyword!
        let newString = firstString + secondString
        rootSearchURL = newString
        let url = URL(string: newString)
        newTableURL = newString
        self.getAllNearbyLocations(url: url!)
        //self.getNearbyLocationsOnce(url: url!)
        print("***************************** Google API Successfuly Received! **********************************")
    }
    
        /***************************************************************/
        
            /***************************************************************/
    
    // This function returns the JSON from a specific URL
    func getJsonFromURL(url: URL, completionHandler: @escaping (NSDictionary) -> ()) {
        Alamofire.request(url).responseJSON { response in
            let json = response.result.value as! NSDictionary
            completionHandler(json)
        }
    }
    
}

    /***************************************************************/
    /***************************************************************/
