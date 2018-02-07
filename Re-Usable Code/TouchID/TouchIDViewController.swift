

//

import UIKit
import LocalAuthentication

class PinCodeLogInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func loginButtonClicked(sender: UIButton) {
        
        // 1. Create a authentication context
        let authenticationContext = LAContext()
        var error:NSError?
        
        // 2. Check if the device has a fingerprint sensor
        // If not, show the user an alert view and bail out!
        guard authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            showAlertViewIfNoBiometricSensorHasBeenDetected()
            return
        }
        
        // 3. Check the fingerprint
        authenticationContext.evaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            localizedReason: "Only awesome people are allowed",
            reply: { [unowned self] (success, error) -> Void in
                
                if( success ) {
                    
                    // Fingerprint recognized
                    // Go to view controller
                    //self.navigateToAuthenticatedViewController()
                    
                }else {
                    
                    // Check if there is an error
                    if let error = error {
                        let message = self.errorMessageForLAErrorCode(errorCode: error.code)
                        //let message = "\(error)"
                        self.showAlertViewAfterEvaluatingPolicyWithMessage(message: message)
                        
                    }
                    
                }
                
        })

        
        
    }
    
    
    func showAlertViewIfNoBiometricSensorHasBeenDetected(){
        showAlertWithTitle(title: "Error", message: "This device does not have a TouchID sensor.")
    }
    

    func showAlertViewAfterEvaluatingPolicyWithMessage( message:String ){
        showAlertWithTitle(title: "Error", message: message)
    }
    

    func showAlertWithTitle( title:String, message:String ) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertVC.addAction(okAction)
        
        //dispatch_async(dispatch_get_main_queue()) { () -> Void in
            
            //self.presentViewController(alertVC, animated: true, completion: nil)
            
        }
    

//    func navigateToAuthenticatedViewController(){
//        if let loggedInVC = storyboard?.instantiateViewControllerWithIdentifier("LoggedInViewController") {
//            dispatch_async(dispatch_get_main_queue()) { () -> Void in
//                navigationController?.pushViewController(loggedInVC, animated: true)
//            }
//        }
//    }
    
    func errorMessageForLAErrorCode(errorCode:Int) -> String{
        
        var message = ""
        
        switch errorCode {
            
        case LAError.appCancel.rawValue:
            message = "Authentication was cancelled by application"
            
        case LAError.authenticationFailed.rawValue:
            message = "The user failed to provide valid credentials"
            
        case LAError.invalidContext.rawValue:
            message = "The context is invalid"
            
        case LAError.passcodeNotSet.rawValue:
            message = "Passcode is not set on the device"
            
        case LAError.systemCancel.rawValue:
            message = "Authentication was cancelled by the system"
            
        case LAError.touchIDLockout.rawValue:
            message = "Too many failed attempts."
            
        case LAError.touchIDNotAvailable.rawValue:
            message = "TouchID is not available on the device"
            
        case LAError.userCancel.rawValue:
            message = "The user did cancel"
            
        case LAError.userFallback.rawValue:
            message = "The user chose to use the fallback"
            
        default:
            message = "Did not find error code on LAError object"
            
        }
        
        return message
        
    }
    
    
    
    
}
