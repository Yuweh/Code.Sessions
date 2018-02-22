//
//  PinCodeLogInViewController.swift
//

import UIKit

class PinCodeLogInViewController: EntryModuleViewController, UITextFieldDelegate{

    @IBOutlet weak var profile_imageView: UIImageView!
    @IBOutlet weak var fullName_label: UILabel!
    @IBOutlet weak var pinCodeTextField: UITextField!
    
    var inputPinCode = false
    var numberOnScreen : Double = 0
    var failedAttempt = 0
    
    fileprivate var primaryUser: PrimaryUser{
        get{
            let usr = GBARealm.objects(PrimaryUser.self)
            print(usr)
            
            return usr.first!
        }
    }
    
    fileprivate var pinUsers: PinUsers{
        get{                //GBARealm.objects(PinUsers.self).first else{ //to be tested
            guard let pinUser = GBARealm.object(ofType: PinUsers.self, forPrimaryKey: "\(primaryUser.userId!)") else{
                fatalError("User not found")
            }
            print(pinUser)
            return pinUser
        }
    }
    
    var currentPresenter: PinCodeLogInPresenter{
        guard let prsntr = self.presenter as? PinCodeLogInPresenter
            else{ fatalError("Error in parsing presenter for RegistrationViewController") }
        return prsntr
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBackground()
        (self._presenter as! PinCodeLogInPresenter).dataBridgeToView = self
        self.presenter.set(view: self)
        self.pinCodeTextField.delegate = self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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

    @IBAction func numbers(_ sender: UIButton)
    {
        if self.inputPinCode == true
        {
            self.pinCodeTextField.text = String(sender.tag)
            self.numberOnScreen = Double(self.pinCodeTextField.text!)!
            self.inputPinCode = false
            if self.pinCodeTextField.text!.count == 6 {
                print("Ready for PIN Code LogIn")
                //self.pinCodeLogInTapped()
                self.existingPinUserValidator(pin: self.pinCodeTextField.text!)
            } else if self.pinCodeTextField.text!.count > 6 {
                //Please Re-Enter your 6 digit PIN
                self.showReusableAlert(title: "PIN Code Incorrect", message: "Please Re-Enter your 6 digit PIN")
            }
        }
        else
        {
            self.pinCodeTextField.text = pinCodeTextField.text! + String(sender.tag)
            numberOnScreen = Double(self.pinCodeTextField.text!)!
            if self.pinCodeTextField.text!.count == 6 {
                print("Ready for PIN Code LogIn")
                //self.pinCodeLogInTapped()
                self.existingPinUserValidator(pin: self.pinCodeTextField.text!)
            } else if self.pinCodeTextField.text!.count > 6 {
                //Please Re-Enter your 6 digit PIN
                self.showReusableAlert(title: "PIN Code Incorrect", message: "Please Re-Enter your 6 digit PIN")
            }
        }
    }
    

    @IBAction func BackTapped(_ sender: UIButton) {
        self.pinCodeTextField.text = ""
    }
    
    
    func pinCodeLogInTapped() {
        print("pinCodeLogInTapped pressed")
        //print(loginForm)
        let newUser = self.primaryUser
        let newForm = LoginFormEntity(mobile: newUser.userNumber!, password: newUser.userPassword!, uuid: "")
        self.currentPresenter.processLogin(form: newForm, controller: self)
    }
    
    func presentDefaultLogin() {
        self.presenter.wireframe.navigate(to: .Loginscreen)
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.presentDefaultLogin()
    }

    private func repopulateProfileInfo(){
        let userProfile = self.primaryUser
        self.fullName_label.text = "\(userProfile.userFullName!)"
        print(userProfile.userFullName!)
    }
    
    
    @IBAction func PRINT(_ sender: UIButton) {
        print(self.pinCodeTextField.text!)
    }
    
    //For Existing PinUsers
    func existingPinUserValidator(pin: String) {
        let enteredPin = pin
        if enteredPin == pinUsers.pinNumber {
            self.showSuccessAlert()
            //self.pinCodeLogInTapped()
        } else {
            self.pinCodeTextField.text = ""
            if self.failedAttempt == 5 {
                self.showMaxAttemptAlert()
                print("Almost for Testing")
            } else {
                print("Still on process")
                self.failedAttempt += 1
                self.showReusableAlert(title: "PIN Code Incorrect", message: "Please Re-Enter your 6 digit PIN")
                print(failedAttempt)
            }
        }
    }
    
    
    
    // Alert for the AlertAction()
    
    func showReusableAlert(title: String, message: String) {
        let alertView = UIAlertController(title: title,
                                          message: message,
                                          preferredStyle:. alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertView, animated: true)
    }
    
    func showSuccessAlert() {
        let alertView = UIAlertController(title: "Login Successful",
                                          message: "Your account will now be processed",
                                          preferredStyle:. alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.pinCodeLogInTapped()}))

        present(alertView, animated: true)
    }
    
    func showMaxAttemptAlert() {
        let alertView = UIAlertController(title: "PIN Code Login Failed",
                                          message: "You have reached maximum number of attempts for PIN Code Login. You will now be directed to our default Login Page",
                                          preferredStyle:. alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.presentDefaultLogin()}))
        present(alertView, animated: true)
    }
    
    //EXP
    func presentVerificationCode(code: String){
        let alert = UIAlertController(title: "CODE", message: code, preferredStyle: .alert)
        
        self.present(alert, animated: true, completion: nil)
        Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { _ in
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    
    
    
    
    //*************************************************************************
}
//*************************************************************************


extension PinCodeLogInViewController: DataDidReceivedFromPinCodeLogin{
    func didReceiveVerificationData(code: String) {
        //self.presentVerificationCode(code: code)
        self.showReusableAlert(title: "Notice", message: "Please check your mobile for verification")
    }
}

extension PinCodeLogInViewController: GBAVerificationCodeDelegate{
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
