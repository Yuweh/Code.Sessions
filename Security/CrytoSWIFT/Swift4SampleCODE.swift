    //TESTCODE -> solves deprecated String issue ("Value of type of String has no member 'bytes')

    // previous code ->
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

    
    //TESTCODE Implemented - to be improved with guard or error handling :D

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
