

    func saveToKeychain() {
        let firstName = self.decryptUserData(key: LockGenerator.key.value, iv: LockGenerator.iv.value, userData: self.user.firstname)
        let lastName = self.decryptUserData(key: LockGenerator.key.value, iv: LockGenerator.iv.value, userData: self.user.lastname)
        
        let userFullName = "\(firstName) \(lastName)"
        let encryptedFullName = self.encryptUserData(key: LockGenerator.key.value, iv: LockGenerator.iv.value, userData: userFullName)
        
        let keychainUserMobile = Keychain(service: "userMobile")
        let keychainPassword = Keychain(service: "password")
        let keychainPinCode = Keychain(service: "pinCode")
        let keychainFullName = Keychain(service: "fullName")
        
        keychainUserMobile[String(self.user.id)] = self.setUserInfo.userNumber
        keychainPassword[String(self.user.id)] = self.setUserInfo.userPassword
        keychainPinCode[String(self.user.id)] = self.setUserInfo.userPIN
        keychainFullName[String(self.user.id)] = encryptedFullName
    }
    
    
