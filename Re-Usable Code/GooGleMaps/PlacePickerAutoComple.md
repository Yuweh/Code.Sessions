import UIKit
import GooglePlacePicker
class AutoCompleteVC: UIViewController {
    
    @IBOutlet var lblName:UILabel!
    @IBOutlet var lblAddress:UILabel!
    @IBOutlet var lblLatitude:UILabel!
    @IBOutlet var lblLongitude:UILabel!
    @IBOutlet var indicatorView:UIActivityIndicatorView!
    @IBOutlet var viewContainer:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("phase 1 - viewDidLoad")
        self.getAutocompletePicker()
       
    }
    func getAutocompletePicker() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
        print("phase 2 - get AutoComplete")
    }
    @IBAction func refresh(sender: UIButton)
    {
        self.viewContainer.isHidden = true
        self.getAutocompletePicker()
        print("phase 3 - refresh")
    }


}
extension AutoCompleteVC: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.viewContainer.isHidden = false
        self.indicatorView.isHidden = true
        self.lblName.text = place.name
        self.lblAddress.text = place.formattedAddress?.components(separatedBy: ", ")
            .joined(separator: "\n")
        self.lblLatitude.text = String(place.coordinate.latitude)
        self.lblLongitude.text = String(place.coordinate.longitude)
        dismiss(animated: true, completion: nil)
        print("phase 4.1 - didAutocompleteWith")
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        self.viewContainer.isHidden = true
        print("phase 4.2 - Error")
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
        self.viewContainer.isHidden = true
        self.indicatorView.isHidden = true
        print("phase 4.3 - wasCancelled")
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        print("phase 5.1 - didRequestAutocompletePredictions")
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        print("phase 5.2 - didUpdateAutocompletePredictions")
    }
    
}
