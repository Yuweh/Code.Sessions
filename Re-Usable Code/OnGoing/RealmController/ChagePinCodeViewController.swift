//
//  ChagePinCodeViewController.swift
//
//

import UIKit

protocol ChangePinCodeVerificationDelegate{
    func ChagePinCodeVerification()
}

class ChagePinCodeViewController: SettingsRootViewController, UITextFieldDelegate{
    
    //Realm Q.Variables
    fileprivate var user: User{
        get{
            guard let usr = GBARealm.objects(User.self).first else{
                fatalError("User not found")
            }
            return usr
        }
    }
    //Experimental could error if not filtered.
    fileprivate var pinUsers: PinUsers{
        get{                //GBARealm.objects(PinUsers.self).first else{ //to be tested
            guard let pinUser = GBARealm.object(ofType: PinUsers.self, forPrimaryKey: "\(user.mobile)") else{
                fatalError("User not found")
            }
            return pinUser
        }
    }
    
    fileprivate var userPinCode: String = ""
    
    private let header_label: UILabel = UILabel()
        .set(fontStyle: GBAText.Font.main(GBAText.Size.header.rawValue).rawValue)
        .set(value: "Enter New PIN code")
        .set(color: GBAColor.black.rawValue)
        .set(alignment: .center)
        .set(lines: 1)
    
    private let subscript_label: UILabel = UILabel()
        .set(fontStyle: GBAText.Font.main(GBAText.Size.subContent.rawValue).rawValue)
        .set(value: "Enter a new 6-digit PIN code to access settings")
        .set(color: GBAColor.gray.rawValue)
        .set(alignment: .center)
        .set(lines: 0)
    
    private let toggleSetView: UIView = UIView()
    private let toggleViews: [GBAToggleView] = [GBAToggleView(), GBAToggleView(), GBAToggleView(), GBAToggleView(), GBAToggleView(), GBAToggleView()]
    
    
    private let input_textField: UITextField = UITextField()
    
    private var pinCodeInput: NSString = ""{
        didSet{
            self.toggleViews.forEach{ $0.toggle = .off }
            for i in 0..<pinCodeInput.length{
                self.toggleViews[i].toggle = .on
            }
            self.toggleSetView.layoutIfNeeded()
            if self.pinCodeInput.length == 6{
                //Exp. function to determine new or existing to be insterted here :D
                //self.navigationItem.rightBarButtonItem?.isEnabled = true
                
                let pinUserProfile = self.pinUsers
                if pinUserProfile.pinNumber != nil {
                    self.existingPinUserCodeRepeater(enteredPinCode: input_textField.text!)
                } else {
                    // For Existing PinUsers
                    print("PinUser is New")
                    newPinUserCodeRepeater(enteredPinCode: input_textField.text!)
                }
                
            }
        }
    }
    
    init(){
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barStyle = .black
        self.view.backgroundColor = .white
        self.title = "Change PIN Code"
        
        let submitBtn = UIBarButtonItem(title: "Submit", style: .plain, target: self, action: #selector(submitBtn_tapped))
        self.navigationItem.rightBarButtonItem = submitBtn
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        self.layoutContents()
        self.newPinUserValidator()
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.input_textField.becomeFirstResponder()
    }
    
    @objc func submitBtn_tapped(){
        
        guard let navController = self.navigationController else { return }
//        SettingsWireframe(navController).navigate(to: .AccessSettingsMainView)
        
        let messages = NSAttributedString(string: "Thank you for using GBA Mobile Banking Application. Your password has now been updated", attributes: [NSAttributedStringKey.font: UIFont(name: "Helvetica Neue", size: GBAText.Size.subContent.rawValue)!])
        
        let content = NSMutableAttributedString()
        content.append(messages)
        
        SettingsWireframe(navController).presentSuccessPage(title: "Support", message: content, doneAction: {
            SettingsWireframe(navController).navigate(to: .AccessSettingsMainView)
            //popToRootViewController(true)
        })
    }
    
    
    private func layoutContents(){
        
        toggleSetView.backgroundColor = .clear
        
        self.input_textField.keyboardType = .numberPad
        self.input_textField.delegate = self
        
        self.view.addSubview(header_label)
        self.view.addSubview(subscript_label)
        self.view.addSubview(toggleSetView)
        self.view.addSubview(input_textField)
        
        self.header_label.translatesAutoresizingMaskIntoConstraints = false
        self.header_label.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor, constant: 30).Enable()
        self.header_label.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).Enable()
        self.header_label.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).Enable()
        
        self.subscript_label.translatesAutoresizingMaskIntoConstraints = false
        self.subscript_label.topAnchor.constraint(equalTo: self.header_label.bottomAnchor, constant: 5).Enable()
        self.subscript_label.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).Enable()
        self.subscript_label.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).Enable()
        
        self.toggleSetView.translatesAutoresizingMaskIntoConstraints = false
        self.toggleSetView.topAnchor.constraint(equalTo: self.subscript_label.bottomAnchor, constant: 50).Enable()
        self.toggleSetView.leadingAnchor.constraint(equalTo: self.subscript_label.leadingAnchor, constant: 35).Enable()
        self.toggleSetView.trailingAnchor.constraint(equalTo: self.subscript_label.trailingAnchor, constant: -35).Enable()
        self.toggleSetView.heightAnchor.constraint(equalTo: self.toggleSetView.widthAnchor, multiplier: 0.1).Enable()
        
        self.view.layoutIfNeeded()
        self.layoutToggleViews()
    }
    
    private func layoutToggleViews(){
        
        let spacing = (self.toggleSetView.width - (self.toggleSetView.height * 6)) / 5
        
        for i in 0..<toggleViews.count{
            toggleViews[i].toggle = .off
            self.toggleSetView.addSubview(self.toggleViews[i])
            
            self.toggleViews[i].translatesAutoresizingMaskIntoConstraints = false
            self.toggleViews[i].topAnchor.constraint(equalTo: self.toggleSetView.topAnchor).Enable()
            self.toggleViews[i].bottomAnchor.constraint(equalTo: self.toggleSetView.bottomAnchor).Enable()
            self.toggleViews[i].widthAnchor.constraint(equalTo: self.toggleViews[i].heightAnchor).Enable()
            
            if i == 0{ self.toggleViews[i].leadingAnchor.constraint(equalTo: self.toggleSetView.leadingAnchor).Enable() }
            else { self.toggleViews[i].leadingAnchor.constraint(equalTo: self.toggleViews[i - 1].trailingAnchor, constant: spacing).Enable() }
            
            if i == toggleViews.count - 1{ self.toggleViews[i].trailingAnchor.constraint(equalTo: self.toggleSetView.trailingAnchor).Enable() }
            toggleViews[i].layoutIfNeeded()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if pinCodeInput.length >= 6{ return false }
        var text = "\(String(describing: textField.text!))\(string)"
        if string == "" { text.removeLast() }
        pinCodeInput = text as NSString
        return true
    }
    
    // header_label .set(value: "Enter PIN code") & subscript_label: .set(value: "We need your PIN code for you to access Settings")
    
    //Exp. PinUser Validator
    func newPinUserValidator() {
        
        let pinUserProfile = self.pinUsers
        print(pinUserProfile.userNumber!)
        
        if pinUserProfile.pinNumber != nil {
            print("Existing PinUser")
            return
        } else {
            self.header_label.set(value: "Set PIN Code")
            self.subscript_label.set(value: "Enter 6 digits to set as a New PIN Code")
        }
        
    }
    
    //Existing PinUser Code Re-Entry
    func existingPinUserCodeRepeater(enteredPinCode: String) {
        
        let changePinUser = pinUsers
        changePinUser.pinNumber = enteredPinCode
        let pinUserProfile = self.pinUsers
        print(pinUserProfile.userNumber!)
        
        if self.userPinCode == "" {
            self.header_label.set(value: "Re-Enter PIN Code")
            self.subscript_label.set(value: "Re-Enter the PIN Code to access Settings")
            self.userPinCode = enteredPinCode
            do {
                try GBARealm.write {
                    GBARealm.add(changePinUser, update: true)
                }
            } catch {
                print(error.localizedDescription)
            }
            self.input_textField.reloadInputViews()
            self.layoutToggleViews()
            
        } else if self.userPinCode != "" {
            self.existingPinUserValidator(enteredPinCode: enteredPinCode)
        } else {
            print("Error")
        }
    }
    
    //For Existing PinUsers
    func existingPinUserValidator(enteredPinCode: String) {
        if enteredPinCode == self.userPinCode {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            self.subscript_label.set(value: "Entered PIN Code is incorrect, please try again")
            self.input_textField.reloadInputViews()
            self.layoutToggleViews()
        }
    }
    
    //New PinUser Code Re-Entry
    func newPinUserCodeRepeater(enteredPinCode: String) {
    }
    
}



