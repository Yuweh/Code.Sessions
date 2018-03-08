//
//  AccessSettingsMainViewController.swift
//  GBA
//
//  Created by Gladys Prado on 12/12/17.
//  Copyright © 2017 Republisys. All rights reserved.
//

import Foundation
import UIKit
import FontAwesome_swift

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
    
    fileprivate var pinUsers: PinUsers{
        get{                //GBARealm.objects(PinUsers.self).first else{ //to be tested
            guard let pinUser = GBARealm.object(ofType: PinUsers.self, forPrimaryKey: "\(user.id)") else{
                fatalError("User not found")
            }
            print(user.mobile + "@MoreVC")
            print(pinUser)
            return pinUser
        }
    }
    
    var selectedVerificationLvl: String = "1"
    var selectedLogInLvl: String = "0"
    
    var verificationForm: VerificationLvlEntity{
                                                //self.selectedVerificationType.type
        return VerificationLvlEntity(authLevel: selectedLogInLvl)
    }
    
    var currentPresenter: AccessSettingsPresenter{
        guard let prsntr = self.presenter as? AccessSettingsPresenter
            else{ fatalError("Error in parsing presenter for AccessSettingsPresenter") }
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
        self.btnRegisterDevice.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.title = "Access Settings"
        repopulateProfileInfo()
        //self.registerUserFuncEnabler()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.title = " "
    }
    
    @objc override func backBtn_tapped(){
        
        // Option 1
        //self.currentPresenter.wireframe.dismiss(true)
        //self.currentPresenter.wireframe.popViewController(animated: true)
        
        // Option 2
        //self.navigationController?.popViewController(animated: true)
        //self.navigationController?.dismiss(animated: true, completion: nil)
        
        // Option 3
        //guard let navController = self.navigationController else { return }
        //SettingsWireframe(navController).dismiss(true)
        //SettingsWireframe(navController).popViewController(animated: true)
        
        // Option 4
        guard let nav = self.navigationController else { fatalError("NavigationViewController can't properly parsed")}
        nav.dismiss(animated: true, completion: nil)
    }
    
    
 //Security Access
    @IBAction func didTapChangePinCode(_ sender: Any) {
        guard let navController = self.navigationController else { return }
        SettingsWireframe(navController).oldPinCodeVC()
    }
    
    @IBAction func didTapChangePassword(_ sender: Any) {
    self.presenter.wireframe.navigate(to: .UpdatePasswordView)
    }

    @IBAction func didTapRegisterDevice(_ sender: Any) {
        //insert function here :D
//        let userProfile = self.primaryUser
//        let userPin = self.pinUsers
        //forKeyChain
//        self.keyChainIntegrator(mobileNumber: userProfile.userNumber!, password: userProfile.userPassword!)
    }
    
//    switchTouchID
    
    
    @IBAction func didTappedTouchIDLogin(_ sender: Any) {
        let pinUserProfile = self.pinUsers
        print(pinUserProfile.userNumber! + "@MoreVC Settings")
        if pinUserProfile.pinNumber == nil {
            self.pinAlertAction()
        } else if pinUserProfile.pinNumber != nil {
            print("for further testing")
            let alert = UIAlertController(title: "Security PIN Required", message: "To provide you better security, we will require you to enter your PIN before changing your Settings.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (alert:UIAlertAction!) -> Void in
                self.didTouchIDLogIn()}))
            alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (alert:UIAlertAction!) -> Void in
                self.switchTouchID.setOn(false, animated: true)}))
            self.present(alert, animated: true, completion: nil)
        } else {
            guard let navController = self.navigationController else { return }
            SettingsWireframe(navController).presentPinCodeVC()
        }
    }
    
    //@IBAction func didTouchIDLogIn(_ sender: UISwitch)
    func didTouchIDLogIn() {
        let userID = self.user
        let userProfile = self.primaryUser //primaryUser
        
        self.segueToSecurityPin()
        
        if switchTouchID.isOn {
            self.switchPINCode.setOn(false, animated: true)
            self.selectedLogInLvl = "2"
            self.newUserLogInValidator(userNumber: userProfile.userNumber!, userFullName: userID.Fullname, userID: String(userID.id), userPassword: userProfile.userPassword!, enteredLogInType: self.selectedLogInLvl)
        } else {
            self.selectedLogInLvl = "0"
            self.newUserLogInValidator(userNumber: userProfile.userNumber!, userFullName: userID.Fullname, userID: String(userID.id), userPassword: userProfile.userPassword!, enteredLogInType: self.selectedLogInLvl)
        }
    }
    
    //switchPINCode
    @IBAction func didPinCodeLogIn(_ sender: UISwitch) {
        let userID = self.user
        let userProfile = self.primaryUser //primaryUser
        print(userProfile)
        
        
        
        if switchPINCode.isOn {
            self.switchTouchID.setOn(false, animated: true)
            self.selectedLogInLvl = "1"
            self.newUserLogInValidator(userNumber: userProfile.userNumber!, userFullName: userID.Fullname, userID: String(userID.id), userPassword: userProfile.userPassword!, enteredLogInType: self.selectedLogInLvl)
        } else {
            self.selectedLogInLvl = "0"
            self.newUserLogInValidator(userNumber: userProfile.userNumber!, userFullName: userID.Fullname, userID: String(userID.id), userPassword: userProfile.userPassword!, enteredLogInType: self.selectedLogInLvl)
        }
    }
    
    
    @IBAction func didTapVerificationCode(_ sender: UISwitch) {
        if switchVerificationCode.isOn {
            self.showSettingChangesAlert()
            print("switchVerificationCode.isOn")
            self.selectedVerificationLvl = "2"
            self.currentPresenter.processVerificationLvl(submittedForm: selectedVerificationLvl)
        } else {
            self.showSettingChangesAlert()
            print("switchVerificationCode.isOff")
            self.selectedVerificationLvl = "1"
            self.currentPresenter.processVerificationLvl(submittedForm: selectedVerificationLvl)
        }
    }
    
    // Alert for the AlertAction()
    func showSettingChangesAlert() {
        let alertView = UIAlertController(title: "Update Settings",
                                          message: "The following changes has been saved",
                                          preferredStyle:. alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertView, animated: true)
    }
    
    private func repopulateProfileInfo(){
        let userProfile = self.user
        let logInProfile = self.primaryUser
        
        if userProfile.auth_level == 2 {
            switchVerificationCode.setOn(true, animated: true)
            print("AuthLevel set to 2")
        } else {
            print("AuthLevel set to 1")
        }
        
        if logInProfile.logInType == "2" {
            switchTouchID.setOn(true, animated: true)
            print("Log-in set to Touch ID")
        } else if logInProfile.logInType == "1" {
            switchPINCode.setOn(true, animated: true)
            print("Log-in set to PinCode ID")
        } else {
            print("Default LogIn")
        }
        
        
        
        
//        if userProfile.id != 22 {
//            viewTouchIDLabel.set(color: .lightGray)
//            viewPINCodeLabel.set(color: .lightGray)
//            viewTouchIDHolder.isUserInteractionEnabled = false
//            viewPINCodeHolder.isUserInteractionEnabled = false
//            btnRegisterDevice.isUserInteractionEnabled = false
//            btnRegisterDevice.titleLabel?.text = "Device Registered"
//            //btnRegisterDevice.titleLabel?.text?.append("Device Registered") //= "Device Registered"
//            return
//        } else {
//            viewTouchIDLabel.set(color: .black)
//            viewPINCodeLabel.set(color: .black)
//            viewTouchIDHolder.isUserInteractionEnabled = true
//            viewPINCodeHolder.isUserInteractionEnabled = true
//            btnRegisterDevice.isUserInteractionEnabled = true
//            btnRegisterDevice.titleLabel?.text = "Change Register"
//            return
//        }
    }
    

    func newUserLogInValidator(userNumber: String, userFullName: String, userID: String, userPassword: String, enteredLogInType: String) {
        let newUser = PrimaryUser() // prev. PrimaryUser -> RegisteredUser
        newUser.userNumber = userNumber
        newUser.userPassword = userPassword
        newUser.logInType  = enteredLogInType
        newUser.userFullName = userFullName
        newUser.userId = userID
        do {
            try GBARealm.write {
                GBARealm.add(newUser, update: true)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func segueToSecurityPin() {
        //self.newPinUserValidator()
        guard let navController = self.navigationController else { return }
        SettingsWireframe(navController).presentPinCodeVC()
    }
    
    // Segue for the Submit Button
//    func transactionSubmitted() {
//        //self.currentPresenter.processVerificationLvl(submittedForm: verificationForm)
//    }

    
    func newPinUserValidator(switchTarget: UISwitch) {
        let pinUserProfile = self.pinUsers
        print(pinUserProfile.userNumber! + "@MoreVC Settings")
        if pinUserProfile.pinNumber == nil {
            self.pinAlertAction()
        } else if pinUserProfile.pinNumber != nil {
            print("for further testing")
            let alert = UIAlertController(title: "Security PIN Required", message: "To provide you better security, we will require you to enter your PIN before changing your Settings.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (alert:UIAlertAction!) -> Void in
                self.transactionSubmitted()}))
            alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (alert:UIAlertAction!) -> Void in
                switchTarget.setOn(false, animated: true)}))
            self.present(alert, animated: true, completion: nil)
        } else {
            guard let navController = self.navigationController else { return }
            SettingsWireframe(navController).presentPinCodeVC()
        }
    }
    
    // Alert for the submitAlertAction()
    func pinAlertAction() {
        let alert = UIAlertController(title: "Set a Security PIN", message: "To provide you better security, we will require you to set a Security PIN before changing your Settings.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.transactionSubmitted()}))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // Segue for the Submit Button
    func transactionSubmitted() {
        print(" ****** transactionSubmitted ****** ")
        guard let navController = self.navigationController else { return }
        SettingsWireframe(navController).presentPinCodeVC()
    }

    func didTappedTouchIDLogin(switchTarget: UISwitch) {
        print("for further testing")
        let alert = UIAlertController(title: "Set a Security PIN", message: "To provide you better security, we will require you to enter your PIN before changing your Settings.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.switchTouchID.setOn(true, animated: true)}))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            switchTarget.setOn(false, animated: true)}))
        self.present(alert, animated: true, completion: nil)
    }
    
    //Exp. Validator and Integrator
//    func keyChainIntegrator(mobileNumber: String, password: String) {
//        let newAccountName = mobileNumber
//        let newPassword = password
//
//        //KeyChain Func
//        do {
//
//            // This is a new account, create a new keychain item with the account name.
//            let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
//                                                    account: newAccountName,
//                                                    accessGroup: KeychainConfiguration.accessGroup)
//
//            // Save the password for the new item.
//            try passwordItem.savePassword(newPassword)
//        } catch {
//            fatalError("Error updating keychain - \(error)")
//        }
//
//    }
    
    //will be moved to Alternative Log-Ins once set.
//    func keyChainVerifier(mobileNumber: String, password: String) -> Bool {
//        let newAccountName = mobileNumber
//        let newPassword = password
//
//        guard newAccountName == primaryUser.userNumber else {
//            return false
//        }
//        do {
//            let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
//                                                    account: newAccountName,
//                                                    accessGroup: KeychainConfiguration.accessGroup)
//            let keychainPassword = try passwordItem.readPassword()
//            return newPassword == keychainPassword
//        }
//        catch {
//            fatalError("Error reading password from keychain - \(error)")
//        }
//        return false
//    }
    
}

extension AccessSettingsMainViewController: DataDidReceiveFromAccessSettings{
    func didReceiveResponse(code: String){
        print("did Receive From Access Settings")
    }
}
