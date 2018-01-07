//
//  AtmFinderViewController.swift
//  GBA
//
//  Created by Francis Jemuel Bergonia on 06/01/2018.
// 
//

import UIKit
import GoogleMaps
import GooglePlacePicker

struct AtmDetailsStruct {
    
    private(set) public var atmName : String = ""
    private(set) public var atmLocation : String = ""
    private(set) public var atmDistance : String = ""
    //
    
    init(atmName: String, atmLocation: String, atmDistance: String) {
        self.atmName = atmName
        self.atmLocation = atmLocation
        self.atmDistance = atmDistance
    }
}

struct AtmCoordinatesStruct {
    private(set) public var atmLatitude : CLLocationDegrees
    private(set) public var atmLongitude : CLLocationDegrees
    
    init(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        self.atmLatitude = latitude
        self.atmLongitude = longitude
    }
}

class AtmFinderViewController: EntryModuleViewController, newLocationsDelegate {
    
    var currentLocation: CLLocation! // This is our current location
    var locationManager = CLLocationManager() // Manage our location
    
    var atmLocationCoordinates: [AtmCoordinatesStruct] = [AtmCoordinatesStruct]()
    var atmCoordinates2D = CLLocationCoordinate2D()
    
    // Store the location coordinates of the nearby locations
    var locationCoordinates = NSMutableArray()
    var atmDetailsArray: [AtmDetailsStruct] = [AtmDetailsStruct]()
    
    
    var currentPresenter: AtmFinderPresenter{
        guard let prsntr = self.presenter as? AtmFinderPresenter
            else{ fatalError("Error in parsing presenter for AtmFinderViewController") }
        return prsntr
    }
    
    //IBOutlets
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var atmTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        atmTableView.delegate = self
        atmTableView.dataSource = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        mapView.delegate = self
        SearchNearbyManager.sharedInstance.delegate = self;
        // Only show the location label if we know our current location and address
        self.atmDetailsArray.removeAll()
        print("**** ViewDidLoad ****")
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.atmTableView.reloadData()
        
        self.title = "ATM Finder"
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barStyle = .black
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(search_tapped(_:)))
        
        self.navigationItem.rightBarButtonItem?.tintColor = GBAColor.white.rawValue
        self.view.backgroundColor = GBAColor.white.rawValue
        
        print("**** ViewWillAppear ****")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.title = " "
    }
    
    @objc private func backNavigate_tapped(_ sender: UIBarButtonItem){
        self.presenter.wireframe.popFromViewController(true)
    }
    
    @objc private func search_tapped(_ sender: UIBarButtonItem){
        self.getAutoCompletePicker()
    }

    
    /***************************************************************/
    
    //AutocompletePicker methods
    
    func getAutoCompletePicker() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
        print("phase 2 - get AutoComplete")
    }
    
    func refresh(sender: UIButton)
    {
        print("phase 3 - refresh")
    }
    
    
    /***************************************************************/
    
    // This is a delegate method for returning new locations from the NearbyMapsManager
    func returnNewLocations(locations: NSArray) {
        
        // Clear our arrays and reset the map
        locationCoordinates.removeAllObjects()
        mapView.clear()
        
        // We loop through the results in our array then plot each one on the map
        for i in 0 ... locations.count - 1 {
            
            let dict = locations[i] as! NSDictionary;
            
            // for locationCoordinate NSArray
            let geometry = dict["geometry"] as! NSDictionary
            let coordinates = geometry["location"] as! NSDictionary
            
            let longitude = coordinates["lng"] as! CLLocationDegrees
            let latitude = coordinates["lat"] as! CLLocationDegrees
            
            let itemLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            //print(locations.count)
            
            
            // for atmDetailsArray
            let atmName = dict["name"] as! String
            let atmAddress = dict["vicinity"] as! String
            
            // to compute distance from current location and atm coordinates
            
            let atmLocation = CLLocation(latitude: latitude, longitude: longitude)
            let userLocation = CLLocation(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
            let distanceMeters = userLocation.distance(from: atmLocation)
            let distanceKilometers = distanceMeters / 1000.00
            let atmCoordinatesDistance = String(Double(round(100 * distanceKilometers) / 100)) + " KM :  " + atmName
            
            
            let atmInfo = AtmDetailsStruct(atmName: atmName, atmLocation: atmAddress, atmDistance: atmCoordinatesDistance)
            let atmCoordinateInfo = AtmCoordinatesStruct(latitude: latitude, longitude: longitude)
            print(atmInfo) //*un/comment to/not test feed
            
            self.appendAtmCoordinatesArray(atmStruct: atmCoordinateInfo)
            self.appendAtmDetailsArray(atmStruct: atmInfo)
            locationCoordinates.addObjects(from: [itemLocation])
            let marker = GMSMarker(position: itemLocation)
            marker.title = dict["name"] as? String
            marker.icon = GMSMarker.markerImage(with: .orange)
            marker.map = mapView
        }
    }
    
    func updateNearbyLocations(currentLocation: CLLocation) {
        SearchNearbyManager.sharedInstance.getNearbyLocationsWithLocation(location: currentLocation)
    }
    
    
    func appendAtmCoordinatesArray(atmStruct: AtmCoordinatesStruct) {
        let atmStructInfo = atmStruct
        self.atmLocationCoordinates.append(atmStructInfo)
        print(atmLocationCoordinates.count)
        self.atmTableView.reloadData()
    }
    
    func appendAtmDetailsArray(atmStruct: AtmDetailsStruct) {
        let atmStructInfo = atmStruct
        self.atmDetailsArray.append(atmStructInfo)
        print(atmDetailsArray.count)
        self.atmTableView.reloadData()
        
        // TODO Remove this check
        if self.atmDetailsArray.count <= 20 {
            print("***************************** RECEIVED 1 API Locations for ATM Details Array **********************************")
        } else {
            print("***************************** RECEIVED >20 API Locations for ATM Details Array **********************************")
        }
    }
    
}


/***************************************************************/

extension AtmFinderViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            mapView.isMyLocationEnabled = false
            mapView.settings.myLocationButton = false
        }
        else {
            
            // This occurs if the user presses the button before our locations have been retreived
            let alert = UIAlertController(title: "Current Location Needed", message: "We need your current location to provide more accurate information and for you to get the most out of this app", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            mapView.animate(toLocation: location.coordinate)
            self.updateNearbyLocations(currentLocation: location)
            currentLocation = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            
            //            // Creates a marker in the center of the map (OPTIONAL).
            //            let marker = GMSMarker()
            //            marker.position = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            //            marker.icon = GMSMarker.markerImage(with: .black)
            //            marker.title = "You are here"
            //            marker.map = mapView
            
        }
    }
}

/***************************************************************/

extension AtmFinderViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
    }
}

/***************************************************************/

extension AtmFinderViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        let atmMapLocation = CLLocationCoordinate2DMake(atmLocationDetails.atmLatitude, atmLocationDetails.atmLongitude)
        self.mapView.camera = GMSCameraPosition(target: atmMapLocation, zoom: 12, bearing: 0, viewingAngle: 0)
        let marker = GMSMarker(position: atmMapLocation)
        marker.icon = GMSMarker.markerImage(with: .green)
        marker.map = mapView
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let atmLocationDetails = atmLocationCoordinates[indexPath.row]
//        let atmDetailsInfo = atmDetailsArray[indexPath.row]
//        let atmMapLocation = CLLocationCoordinate2DMake(atmLocationDetails.atmLatitude, atmLocationDetails.atmLongitude)
//        //let atmCurrentLocation = CLLocation(latitude: atmLocationDetails.atmLatitude, longitude: atmLocationDetails.atmLongitude)
//        //self.updateNearbyLocations(currentLocation: atmCurrentLocation)
//        mapView.camera = GMSCameraPosition(target: atmMapLocation, zoom: 15, bearing: 0, viewingAngle: 0)
//        //self.currentLocation = atmCurrentLocation
//        let marker = GMSMarker(position: atmMapLocation)
//        marker.icon = GMSMarker.markerImage(with: .green)
//        marker.map = mapView
//        marker.title = atmDetailsInfo.atmName
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return atmDetailsArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}

/**************************EXPERIMENTAL AUTOCOMPLETE SEARCH*************************************/

extension AtmFinderViewController: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let newCurrentLocation = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        self.updateNearbyLocations(currentLocation: newCurrentLocation)
        mapView.camera = GMSCameraPosition(target: newCurrentLocation.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        self.currentLocation = CLLocation(latitude: newCurrentLocation.coordinate.latitude, longitude: newCurrentLocation.coordinate.longitude)
        self.atmDetailsArray.removeAll()
        self.atmLocationCoordinates.removeAll()
        dismiss(animated: true, completion: nil)
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        //UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        //UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}

/***************************************************************/
/*******************CODE ENDS HERE **********************/




