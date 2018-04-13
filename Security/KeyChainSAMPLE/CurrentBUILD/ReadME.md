

SAVE

      let keychainUserMobile = Keychain(service: "userMobile")
      keychainUserMobile[String(self.user.id)] = self.setUserInfo.userNumber
      
RETRIEVE

       let keychainUserMobile = Keychain(service: "userMobile")
       let userNumber = keychainUserMobile[registeredUser.userID!]

DELETE

      keychainUserMobile[String(self.user.id)] = nil

or

        do {
            try keychainUserMobile.remove(String(self.user.id))
        } catch let error {
            print("error: \(error)")
        }
        
  
#Sample code


SAVE

      let newUserPIN = self.encryptUserData(key: LockGenerator.key.value, iv: LockGenerator.iv.value, userData: enteredPinCode)

      let keychainUserPIN = Keychain(service: "userPIN")
      keychainUserPIN[String(self.user.id)] = newUserPIN

RETRIEVE

      let keychainUserPIN = Keychain(service: "userPIN")
      let userPIN = keychainUserPIN[registeredUser.userID!]
      
      let newUserPassword = self.decryptUserData(key: LockGenerator.key.value, iv: LockGenerator.iv.value, userData: userPIN!)
      
      
