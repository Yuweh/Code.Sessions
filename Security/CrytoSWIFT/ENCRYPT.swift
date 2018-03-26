func encryptUserData(key: String, iv: String, userData: String) -> String {
        let data = userData.data(using: .utf8)!
        let encrypted = try! AES(key: key.bytes, blockMode: .CBC(iv: iv.bytes), padding: .pkcs7).encrypt([UInt8](data))
        let encryptedData = Data(encrypted)
        return encryptedData.base64EncodedString()
    }
    
    
    func encryptUserInfo() {
        let newUser = User()
        let userProfile = self.profile!
        newUser.id = userProfile.id
        newUser.firstname = self.encryptUserData(key: LockGenerator.key.value, iv: LockGenerator.iv.value, userData: userProfile.firstname)
        newUser.lastname = self.encryptUserData(key: LockGenerator.key.value, iv: LockGenerator.iv.value, userData: userProfile.lastname)
        newUser.mobile = self.encryptUserData(key: LockGenerator.key.value, iv: LockGenerator.iv.value, userData: userProfile.mobile)
        newUser.email = self.encryptUserData(key: LockGenerator.key.value, iv: LockGenerator.iv.value, userData: userProfile.email)
        
        do {
            try GBARealm.write {
                GBARealm.add(newUser, update: true)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
