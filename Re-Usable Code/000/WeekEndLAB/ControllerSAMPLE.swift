//
//  TouchIDLogInViewController.swift
//

import UIKit
import LocalAuthentication

class TouchIDLogInViewController: EntryModuleViewController{

    @IBOutlet weak var profile_imageView: UIImageView!
    @IBOutlet weak var fullName_label: UILabel!
    var failedAttempt = 0
    
    //EXP.
    fileprivate var user: User{
        get{
            guard let usr = GBARealm.objects(User.self).first else{
                fatalError("User not found")
            }
            return usr
        }
    }
    
    fileprivate var primaryUser: PrimaryUser{
        get{
            guard let usr = GBARealm.objects(PrimaryUser.self).first else{
                fatalError("User not found")
            }
            return usr
        }
    }
    
    //Adapted Form LogIn
    private var loginForm: LoginFormEntity{
        let userProfile = self.primaryUser
        //print(userProfile)
        return LoginFormEntity(mobile: userProfile.userNumber!, password: userProfile.userPassword!, uuid: "")
    }
    
    var currentPresenter: TouchIDLogInPresenter{
        guard let prsntr = self.presenter as? TouchIDLogInPresenter
            else{ fatalError("Error in parsing presenter for RegistrationViewController") }
        return prsntr
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBackground()
        (self._presenter as! TouchIDLogInPresenter).dataBridgeToView = self
        self.presenter.set(view: self)
        self.navigationController?.isNavigationBarHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.failedAttempt += 1
        self.authenticateUser()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    fileprivate func setBackground(){
        let backgroundImage = UIImage(imageLiteralResourceName: "Login_BG").cgImage
        let layer = CALayer()
        let overlay = CAGradientLayer()
        
        layer.frame = UIScreen.main.bounds
        layer.contents = backgroundImage
        layer.contentsGravity = kCAGravityResizeAspectFill
        
        overlay.set(frame: self.view.bounds)
            .set(start: CGPoint(x: 0, y: 0))
            .set(end: CGPoint(x: 0, y: 1))
            .set(colors: [.white, .primaryBlueGreen])
            .set(locations: [0, 1.4])
            .opacity = 0.8
        
        self.view.layer.insertSublayer(layer, at: 0)
        self.view.layer.insertSublayer(overlay, at: 1)
        
    }
    
    private func repopulateProfileInfo(){
        let userProfile = self.primaryUser
        self.fullName_label.text = "\(userProfile.userFullName!)"
    }

    
    func authenticateUser() {
        let authContext : LAContext = LAContext()
        var error: NSError?
        
        if authContext.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error){
            authContext.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Biometric Check for GBA", reply: {successful, error -> Void in
                if successful{
                    print("TouchID Yes")
                    self.showLoginSuccess()
                }
                else {
                    print("TouchID No")
                    self.failedAttempt += 1
                    //self.showAlternativeAttemptAlert(title: "Touch ID Authentication Failed", message: "Do you  like to try our Default Login Page?")
                
                    let message: String
                    
                    switch error {
                    case LAError.appCancel?:
                        message = "Authentication was cancelled by application"
                        
                    case LAError.authenticationFailed?:
                        message = "The user failed to provide valid credentials"
                         //self.showAlternativeAttemptAlert(title: "Login Failed", message: "You have failed to provide valid credentials for TouchID Login. Do you like to be directed to our default Login Page")
                        
                    case LAError.invalidContext?:
                        message = "The context is invalid"
                        
                    case LAError.passcodeNotSet?:
                        message = "Passcode is not set on the device"
                        
                    case LAError.systemCancel?:
                        message = "Authentication was cancelled by the system"
                        
                    case LAError.touchIDLockout?:
                        message = "Too many failed attempts."
                        self.showMaxAttemptAlert()
                        
                    case LAError.touchIDNotAvailable?:
                        message = "TouchID is not available on the device"
                        
                    case LAError.userCancel?:
                        message = "The user did cancel"
                        
                    case LAError.userFallback?:
                        message = "You may choose Login with Password to continue"
                        
                    default:
                        message = "Face ID/Touch ID may not be configured"
                    }
                    self.showAlertWithTitle(title: "Login Failed", message: message)
                }
            }
            )
        }
    }
    
    
    @IBAction func loginButtonClicked(sender: UIButton) {
        if self.failedAttempt == 5 {
            self.showMaxAttemptAlert()
            print("Almost for Testing")
        } else {
            print("Still on process")
            //self.failedAttempt += 1
            self.authenticateUser()
            print(failedAttempt)
        }
    }
    
    func presentDefaultLogin() {
        self.presenter.wireframe.navigate(to: .Loginscreen)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.presentDefaultLogin()
    }
    
    func showAlertWithTitle(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    func showLoginSuccess() {
        let alertController = UIAlertController(title: nil, message: "Touch ID Authentication Succeeded", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.navigateToDashboard()}))
        present(alertController, animated: true, completion: nil)
    }
    
    func showFailAlert() {
        let alertView = UIAlertController(title: nil,
                                          message: "Touch ID Authentication Failed",
                                          preferredStyle:. alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertView, animated: true)
    }
    
    func navigateToDashboard(){
            let newUser = self.primaryUser
            let newForm = LoginFormEntity(mobile: newUser.userNumber!, password: newUser.userPassword!, uuid: "")
            self.currentPresenter.processLogin(form: newForm, controller: self)
    }

    func showAlternativeAttemptAlert(title: String, message: String) {
        let alertView = UIAlertController(title: title,
                                          message: message,
                                          preferredStyle:. alert)
        alertView.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.presentDefaultLogin()}))
        alertView.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        present(alertView, animated: true)
    }
    
    func showMaxAttemptAlert() {
        let alertView = UIAlertController(title: "TouchID Login Failed",
                                          message: "You have reached maximum number of attempts for PIN Code Login. You will now be directed to our default Login Page",
                                          preferredStyle:. alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.presentDefaultLogin()}))
        //        let okAction = UIAlertAction(title: "Ok", style: .default)
        //        alertView.addAction(okAction)
        present(alertView, animated: true)
    }
    
}

extension TouchIDLogInViewController: DataDidReceivedFromTouchIDLogin{
    func didReceiveVerificationData(code: String) {
    }
}

extension TouchIDLogInViewController: GBAVerificationCodeDelegate{
    
    func ResendButton_tapped(sender: UIButton) {
        self.currentPresenter.resendVerificationCode{
            
            var countdown = 60
            
            sender.isEnabled = false
            sender.setTitleColor(GBAColor.darkGray.rawValue, for: .disabled)
            
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
                sender.setTitle("RESEND CODE (\(countdown))", for: .disabled)
                
                let _ = countdown-- < 0 ? (timer.invalidate(), (sender.isEnabled = true)): ((),())
            })
        }
    }
    
    func GBAVerification() {
        guard let nav = self.navigationController else{
            fatalError("Navigation View Controller was  not set in LiginViewController")
        }
        DashboardWireframe(nav).presentTabBarController()
    }
}
