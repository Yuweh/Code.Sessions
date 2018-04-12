    
    func createUserWithFirebase() {
        self.setButtonEnabled()
        let userProfile = self.setUserInfo
        let userID = self.user
        let userEmail = self.decryptUserData(key: LockGenerator.key.value, iv: LockGenerator.iv.value, userData: userID.email)
        let password = self.decryptUserData(key: LockGenerator.key.value, iv: LockGenerator.iv.value, userData: userProfile.userPassword!)
        //createUser or signIn
        Auth.auth().createUser(withEmail: userEmail, password: password) { (user, error) in
            if error != nil {
                print(error!)
            } else {
                //let firebaseUserID = Auth.auth().currentUser!.uid
                self.saveToKeychain()
                self.newUserLogInValidator(registeredUserID: String(self.user.id), enteredLogInType: LogInPreference.Password.type)
                //self.currentPresenter.setDeviceRequest(token: firebaseUserID, uuid: UUIDGenerator.deviceUUID.value)
            }
        }
    }
    
    
    func signInWithFirebase() {
        let userEmail = self.decryptUserData(key: LockGenerator.key.value, iv: LockGenerator.iv.value, userData: self.user.email)
        let password = self.decryptUserData(key: LockGenerator.key.value, iv: LockGenerator.iv.value, userData: self.setUserInfo.userPassword!)

        
        Auth.auth().signIn(withEmail: userEmail, password: password) { (user, error) in
            if error != nil {
                print(error!)
            } else {
                //let firebaseUserID = Auth.auth().currentUser!.uid
                self.saveToKeychain()
                self.newUserLogInValidator(registeredUserID: String(self.user.id), enteredLogInType: LogInPreference.Password.type)
                //self.currentPresenter.setChangeDevice(token: firebaseUserID, uuid: UUIDGenerator.deviceUUID.value)
            }
        }
    }




//
//

import Foundation
import UIKit
import FontAwesome_swift
import KeychainAccess
import CryptoSwift
import Firebase

class AccessSettingsMainViewController: SettingsRootViewController {
    
    @IBOutlet weak var viewTouchIDLabel: UILabel!
    @IBOutlet weak var viewPINCodeLabel: UILabel!
    @IBOutlet weak var viewTouchIDHolder: UIView!
    @IBOutlet weak var viewPINCodeHolder: UIView!
    @IBOutlet weak var viewVerificationCodeHolder: UIView!
    @IBOutlet weak var btnChangePassword: UIButton!
    @IBOutlet weak var btnChangeAccesSettingPINCode: UIButton!
    @IBOutlet weak var btnRegisterDevice: UIButton!
    
    //switches
    @IBOutlet weak var switchTouchID: UISwitch!
    @IBOutlet weak var switchPINCode: UISwitch!
    @IBOutlet weak var switchVerificationCode: UISwitch!
    @IBOutlet weak var btnKeychainChecker: UIButton!
    
    //Realm Objects
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
            guard let usrP = GBARealm.objects(PrimaryUser.self).first else{
                fatalError("User not found")
            }
            return usrP
        }
    }
    
    fileprivate var registeredUser: RegisteredUser{
        get{
            guard let usr = GBARealm.objects(RegisteredUser.self).first else{
                fatalError("User not found")
            }
            return usr
        }
    }
    
    var currentPresenter: AccessSettingsPresenter{
        guard let prsntr = self.presenter as? AccessSettingsPresenter
            else{ fatalError("Error in parsing presenter for AccessSettings Presenter") }
        return prsntr
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.presenter.set(view: self)
        (self._presenter as! AccessSettingsPresenter).dataBridge = self
        viewTouchIDHolder.applyCornerRadius(10)
        viewPINCodeHolder.applyCornerRadius(10)
        viewVerificationCodeHolder.applyCornerRadius(10)
        self.navigationController?.navigationBar.barStyle = .default
        let backBtn = UIBarButtonItem(title: String.fontAwesomeIcon(name: .angleLeft), style: .plain, target: self, action: #selector(backBtn_tapped))
        backBtn.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.fontAwesome(ofSize: GBAText.Size.normalNavbarIcon.rawValue)], for: .normal)
        self.navigationItem.leftBarButtonItem = backBtn
        //self.btnRegisterDevice.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.title = "Access Settings"
        repopulateProfileInfo()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.title = " "
    }
    
    @objc override func backBtn_tapped(){
        guard let nav = self.navigationController else { fatalError("NavigationViewController can't properly parsed")}
        nav.dismiss(animated: true, completion: nil)
    }
    
    
 //Security Access
    @IBAction func didTapChangePinCode(_ sender: Any) {
        let pinUserProfile = self.registeredUser
        if pinUserProfile.userPIN == nil {
            let alert = UIAlertController(title: SettingsMessages.oldUser.title, message: SettingsMessages.oldUser.messages, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (alert:UIAlertAction!) -> Void in
                guard let navController = self.navigationController else { return }
                SettingsWireframe(navController).presentPinCodeVC()
            }))
            self.present(alert, animated: true, completion: nil)
        } else if pinUserProfile.userPIN != nil {
            guard let navController = self.navigationController else { return }
            SettingsWireframe(navController).oldPinCodeVC()
        }
    }
    
    @IBAction func didTapChangePassword(_ sender: Any) {
    self.presenter.wireframe.navigate(to: .UpdatePasswordView)
    }

    func saveToKeychain() {
        let userInfo = self.user
        let userProfile = self.primaryUser //primaryUser
        
        let firstName = self.decryptUserData(key: LockGenerator.key.value, iv: LockGenerator.iv.value, userData: userInfo.firstname)
        let lastName = self.decryptUserData(key: LockGenerator.key.value, iv: LockGenerator.iv.value, userData: userInfo.lastname)
        
        let userFullName = "\(firstName) \(lastName)"
        let encryptedFullName = self.encryptUserData(key: LockGenerator.key.value, iv: LockGenerator.iv.value, userData: userFullName)
        
        //let userInfo = self.registeredUser
        let keychainUserMobile = Keychain(service: "userMobile")
        let keychainPassword = Keychain(service: "password")
        //let keychainPinCode = Keychain(service: "pinCode")
        let keychainFullName = Keychain(service: "fullName")
        
        keychainUserMobile[String(userInfo.id)] = userProfile.userNumber
        keychainPassword[String(userInfo.id)] = userProfile.userPassword
        //keychainPinCode[String(userID.id)] = userProfile.userPIN
        keychainFullName[String(userInfo.id)] = encryptedFullName
    }
    
    func authWithFirebase() {
        let userProfile = self.primaryUser
        let userID = self.user
        let userEmail = self.decryptUserData(key: LockGenerator.key.value, iv: LockGenerator.iv.value, userData: userID.email)
        let password = self.decryptUserData(key: LockGenerator.key.value, iv: LockGenerator.iv.value, userData: userProfile.userPassword!)
        Auth.auth().createUser(withEmail: userEmail, password: password) { (user, error) in
            if error != nil {
                print(error!)
            } else {
                print("Registration Successful and will be saved at keychain")
                
                let uuidString = UUID().uuidString
                let uuidToSet = "GBA02-"+"\(uuidString)"
                let firebaseUserID = Auth.auth().currentUser!.uid
                
                print(uuidString)
                print(uuidToSet)
                print(firebaseUserID)
                
                //self.saveToKeychain()
                //SaveToRealm ->
                 //self.newUserLogInValidator(registeredUserID: String(self.user.id), enteredLogInType: LogInPreference.Password.type)
                
                //APIcallforRegisterDevice ->
                self.currentPresenter.setDeviceType(token: firebaseUserID, uuid: uuidToSet)
                
                //for IBOutlet
                self.btnRegisterDevice.titleLabel?.text = "Change Register"
            }
        }
    }
    
    @IBAction func didTapRegisterDevice(_ sender: Any) {
        let registeredUser = self.registeredUser
        
        if registeredUser.userId == "0"{
            self.authWithFirebase()
        } else {
            print("delete items and have API Call for Change Register")
        }
    }
    
    func switchPinProcessor(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.didPinCodeLogIn()}))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.switchPINCode.setOn(false, animated: true)}))
        self.present(alert, animated: true, completion: nil)
    }
    
    func switchTouchIDProcessor(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.didTouchIDLogIn()}))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.switchTouchID.setOn(false, animated: true)}))
        self.present(alert, animated: true, completion: nil)
    }
    
    //switchTouchID
    @IBAction func didTappedTouchIDLogin(_ sender: Any) {
        let pinUserProfile = self.registeredUser
        if pinUserProfile.userPIN == nil {
            self.switchTouchIDProcessor(title: SettingsMessages.newUser.title, message: SettingsMessages.newUser.messages)
        } else if pinUserProfile.userPIN != nil {
            self.switchTouchIDProcessor(title: SettingsMessages.oldUser.title, message: SettingsMessages.oldUser.messages)
        } else {
            guard let navController = self.navigationController else { return }
            SettingsWireframe(navController).presentPinCodeVC()
        }
    }
    
    //@IBAction func didTouchIDLogIn(_ sender: UISwitch)
    func didTouchIDLogIn() {
        self.segueToSecurityPin()
        if switchTouchID.isOn {
            self.switchPINCode.setOn(false, animated: true)
            self.newUserLogInValidator(registeredUserID: String(user.id), enteredLogInType: LogInPreference.TouchId.type)
        } else {
            self.newUserLogInValidator(registeredUserID: String(user.id), enteredLogInType: LogInPreference.Password.type)
        }
    }
    
//switchPINCode
    @IBAction func didTappedPINcodeLogin(_ sender: Any) {
        let pinUserProfile = self.registeredUser
        if pinUserProfile.userPIN == nil {
            self.switchPinProcessor(title: SettingsMessages.newUser.title, message: SettingsMessages.newUser.messages)
        } else if pinUserProfile.userPIN != nil {
            self.switchPinProcessor(title: SettingsMessages.oldUser.title, message: SettingsMessages.oldUser.messages)
        }
    }
    
    
    //@IBAction func didPinCodeLogIn(_ sender: UISwitch)
    func didPinCodeLogIn() {
        self.segueToSecurityPin()
        if switchPINCode.isOn {
            self.switchTouchID.setOn(false, animated: true)
            self.newUserLogInValidator(registeredUserID: String(user.id), enteredLogInType: LogInPreference.PinCode.type)
        } else {
            self.newUserLogInValidator(registeredUserID: String(user.id), enteredLogInType: LogInPreference.Password.type)
        }
    }
    
    @IBAction func didTapVerificationCode(_ sender: UISwitch) {
        if switchVerificationCode.isOn {
            self.currentPresenter.processVerificationLvl(submittedForm: VerificationType.TwoWay.type)
        } else {
            self.currentPresenter.processVerificationLvl(submittedForm: VerificationType.OneWay.type)
        }
    }
    
    // Alert for the AlertAction()
    func showSettingChangesAlert(title: String, message: String) {
        let alertView = UIAlertController(title: title,
                                          message: message,
                                          preferredStyle:. alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertView, animated: true)
    }

    func encryptUserData(key: String, iv: String, userData: String) -> String {
            let data = userData.data(using: .utf8)!
            let encrypted = try! AES(key: key.bytes, blockMode: .CBC(iv: iv.bytes), padding: .pkcs7).encrypt([UInt8](data))
            let encryptedData = Data(encrypted)
            return encryptedData.base64EncodedString()
    }
    
    func decryptUserData(key: String, iv: String, userData: String) -> String {
        let data = Data(base64Encoded: userData)!
        let decrypted = try! AES(key: key.bytes, blockMode: .CBC(iv: iv.bytes), padding: .pkcs7).decrypt([UInt8](data))
        let decryptedData = Data(decrypted)
        return String(bytes: decryptedData.bytes, encoding: .utf8) ?? "Could not decrypt"
    }
    
    private func repopulateProfileInfo(){
        
        let userProfile = self.user
        let logInProfile = self.registeredUser
        
        // For Authorization Level
        if userProfile.auth_level == 2 {
            switchVerificationCode.setOn(true, animated: false)
        } else {
            switchVerificationCode.setOn(false, animated: false)
        }
        
        // For Login Type of Registered User
        if logInProfile.logInType == "2" {
            switchTouchID.setOn(true, animated: false)
        } else if logInProfile.logInType == "1" {
            switchPINCode.setOn(true, animated: false)
        } else {
            print("Default LogIn")
        }
        
        // To validate if Registered or Not
        if logInProfile.userId == "0" {
            viewTouchIDLabel.set(color: .lightGray)
            viewPINCodeLabel.set(color: .lightGray)
            switchPINCode.setOn(false, animated: false)
            switchTouchID.setOn(false, animated: false)
            viewTouchIDHolder.isUserInteractionEnabled = false
            viewPINCodeHolder.isUserInteractionEnabled = false
            btnRegisterDevice.isUserInteractionEnabled = true
            btnChangeAccesSettingPINCode.isUserInteractionEnabled = false
            btnRegisterDevice.titleLabel?.text = "Register Device"
        } else if logInProfile.userId == String(userProfile.id) {
                viewTouchIDLabel.set(color: .black)
                viewPINCodeLabel.set(color: .black)
                viewTouchIDHolder.isUserInteractionEnabled = true
                viewPINCodeHolder.isUserInteractionEnabled = true
                btnRegisterDevice.isUserInteractionEnabled = true
                btnRegisterDevice.titleLabel?.text = "Change Register"
                return
            } else if logInProfile.userId != String(userProfile.id) {
                viewTouchIDLabel.set(color: .lightGray)
                viewPINCodeLabel.set(color: .lightGray)
                switchPINCode.setOn(false, animated: false)
                switchTouchID.setOn(false, animated: false)
                viewTouchIDHolder.isUserInteractionEnabled = false
                viewPINCodeHolder.isUserInteractionEnabled = false
                btnRegisterDevice.isUserInteractionEnabled = false
                btnChangeAccesSettingPINCode.isUserInteractionEnabled = false
                btnRegisterDevice.titleLabel?.text = "Device Registered"
                return
            }
    }
    
    //func newUserLogInValidator(enteredLogInType: String)
    func newUserLogInValidator(registeredUserID: String, enteredLogInType: String) {
        let userProfile = self.registeredUser
        let newUser = RegisteredUser()
        newUser.userId = registeredUserID
        newUser.userPIN = userProfile.userPIN
        newUser.logInType = enteredLogInType
        
        //Realm
        do {
            try GBARealm.write {
                GBARealm.add(newUser, update: true)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func segueToSecurityPin() {
        guard let navController = self.navigationController else { return }
        SettingsWireframe(navController).presentPinCodeVC()
    }
    
}

extension AccessSettingsMainViewController: DataDidReceiveFromAccessSettings{
    func didReceiveResponse(code: String){
        print("did Receive From Access Settings")
    }
}

extension AccessSettingsMainViewController: GBAVerificationCodeDelegate{
    func ResendButton_tapped(sender: UIButton) {
        self.currentPresenter.wireframe.popToRootViewController(true)
    }
    
    
    func GBAVerification() {
        //guard let navController = self.navigationController else { return }
        
        let messages = NSAttributedString(string: "Thank you for registering this device to your account. You can now connect with anyone through their wallet and move money across the globe real-time.", attributes: [NSAttributedStringKey.font: UIFont(name: "Helvetica Neue", size: GBAText.Size.subContent.rawValue)!])
        
        let content = NSMutableAttributedString()
        content.append(messages)
        
        self.currentPresenter.wireframe.presentSuccessPage(title: "Device Registered", message: content, doneAction: {
            self.currentPresenter.wireframe.popToRootViewController(true)
            //SettingsWireframe(navController).navigate(to: .AccessSettingsMainView)
        })
    }
}

