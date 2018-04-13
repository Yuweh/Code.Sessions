

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
