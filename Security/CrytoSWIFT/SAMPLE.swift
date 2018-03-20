import Cryptoswift

    func encryptUserData(key: String, iv: String, userData: String) -> String {
        do {
            let data = userData.data(using: .utf8)!
            let encrypted = try! AES(key: key.bytes, blockMode: .CBC(iv: iv.bytes), padding: .pkcs7).encrypt([UInt8](data))
            let encryptedData = Data(encrypted)
            return encryptedData.base64EncodedString()
        }
        catch {
            print("error")
        }
    }
    
    func decryptUserData(key: String, iv: String, userData: String) -> String {
        let data = Data(base64Encoded: userData)!
        let decrypted = try! AES(key: key.bytes, blockMode: .CBC(iv: iv.bytes), padding: .pkcs7).decrypt([UInt8](data))
        let decryptedData = Data(decrypted)
        return String(bytes: decryptedData.bytes, encoding: .utf8) ?? "Could not decrypt"
    }
