
    func decryptUserData(key: String, iv: String, userData: String) -> String {
        let data = Data(base64Encoded: userData)!
        let decrypted = try! AES(key: key.bytes, blockMode: .CBC(iv: iv.bytes), padding: .pkcs7).decrypt([UInt8](data))
        let decryptedData = Data(decrypted)
        return String(bytes: decryptedData.bytes, encoding: .utf8) ?? "Could not decrypt"
    }
    
    APPLY to let newFullName = self.decryptUserData(key: LockGenerator.key.value, iv: LockGenerator.iv.value, userData: userProfile.Fullname)
        
