
extension MainMapVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let atmDetailsInfo = atmDetailsArray[indexPath.row]
        cell.textLabel?.text = atmDetailsInfo.atmName
        cell.detailTextLabel?.text = atmDetailsInfo.atmLocation
        cell.textLabel?.text = atmDetailsInfo.atmDistance
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let atmLocationDetails = atmLocationCoordinates[indexPath.row]
        let atmDetailsInfo = atmDetailsArray[indexPath.row]
        let atmMapLocation = CLLocationCoordinate2DMake(atmLocationDetails.atmLatitude, atmLocationDetails.atmLongitude)
        //let atmCurrentLocation = CLLocation(latitude: atmLocationDetails.atmLatitude, longitude: atmLocationDetails.atmLongitude)
        //self.updateNearbyLocations(currentLocation: atmCurrentLocation)
        mapView.camera = GMSCameraPosition(target: atmMapLocation, zoom: 15, bearing: 0, viewingAngle: 0)
        //self.currentLocation = atmCurrentLocation
        let marker = GMSMarker(position: atmMapLocation)
        marker.icon = GMSMarker.markerImage(with: .green)
        marker.map = mapView
        marker.title = atmDetailsInfo.atmName
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return atmDetailsArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}
    /***************************************************************/
