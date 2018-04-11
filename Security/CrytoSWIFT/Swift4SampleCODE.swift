    //TESTCODE
    
    //DECRYPT (Simple version / no padding and blockmode specified)
    func decryptUserData(key: String, iv: String, userData: String) -> String {
        let data = Data(base64Encoded: userData)!
        let decrypted = try! AES(key: key, iv: iv).decrypt([UInt8](data))
        let decryptedData = Data(decrypted)
        return String(bytes: decryptedData.bytes, encoding: .utf8) ?? "Could not decrypt"
    }
    
    //ENCRYPT 
    func encryptUserData(key: String, iv: String, userData: String) -> String {
        let data = userData.data(using: .utf8)!
        let encrypted = try! AES(key: key, iv: iv).encrypt([UInt8](data))
        let encryptedData = Data(encrypted)
        return encryptedData.base64EncodedString()
    }
