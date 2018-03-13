  //Keychain Used: https://github.com/kishikawakatsumi/KeychainAccess


    //SAVE
    @IBAction func didTapRegisterDevice(_ sender: Any) {
        
        let userID = self.user
        let userPIN = self.pinUsers
        let userProfile = self.primaryUser //primaryUser
        
        let keychainUserMobile = Keychain(service: "userMobile")
        let keychainPassword = Keychain(service: "password")
        let keychainPinCode = Keychain(service: "pinCode")
        let keychainFullName = Keychain(service: "fullName")
        
        keychainUserMobile[String(userID.id)] = userProfile.userNumber
        keychainPassword[String(userID.id)] = userProfile.userPassword
        keychainPinCode[String(userID.id)] = userPIN.pinNumber
        keychainFullName[String(userID.id)] = userProfile.userFullName
        
    }
    

       
    //RETRIEVE 
    @IBAction func didTapKechainChecker(_ sender: UIButton) {
        
        let userID = self.user
        
        let keychainUserMobile = Keychain(service: "userMobile")
        let keychainPassword = Keychain(service: "password")
        let keychainPinCode = Keychain(service: "pinCode")
        let keychainFullName = Keychain(service: "fullName")
        
        do {
            let item1 = keychainUserMobile[String(userID.id)]
            let item2 = keychainPassword[String(userID.id)]
            let item3 = keychainPinCode[String(userID.id)]
            let item4 = keychainFullName[String(userID.id)]
            print(item1!, item2!, item3!, item4!)
        } catch let error {
            print("error: \(error)")
        }
        
    }
