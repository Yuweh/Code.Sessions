/**************************EXPERIMENTAL TABLE VIEWCELL DELEGATES*************************************/


extension AtmFinderViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return atmDetailsArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: AtmDetailsCellView = tableView.dequeueReusableCell(withIdentifier: "atmDetailsCell", for: indexPath) as? AtmDetailsCellView else {
            fatalError("The dequeued cell is not an instance of AtmDetailsViewCell.")
        }
        let atmDetailsInfo = atmDetailsArray[indexPath.row]
        cell.atmName?.text = atmDetailsInfo.atmName
        cell.atmAddress?.text = atmDetailsInfo.atmLocation
        cell.atmDistance?.text = atmDetailsInfo.atmDistance
        print(cell.frame)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("SELECT PLACE")
        let atmLocationDetails = atmLocationCoordinates[indexPath.row]
        let atmMapLocation = CLLocationCoordinate2DMake(atmLocationDetails.atmLatitude, atmLocationDetails.atmLongitude)
        self.mapView.camera = GMSCameraPosition(target: atmMapLocation, zoom: 15, bearing: 0, viewingAngle: 0)
        let marker = GMSMarker(position: atmMapLocation)
        marker.icon = GMSMarker.markerImage(with: .green)
        marker.map = mapView
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}
