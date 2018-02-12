## Keychain Reader for Alternative Log-Ins

    //will be moved to Alternative Log-Ins once set.
    func keyChainVerifier(mobileNumber: String) -> Bool {
        let newAccountName = mobileNumber
        let newPassword = password
        
        guard newAccountName == primaryUser.userNumber else {
            return false
        }
        do {
            let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                    account: newAccountName,
                                                    accessGroup: KeychainConfiguration.accessGroup)
            let keychainPassword = try passwordItem.readPassword()
            return keychainPassword
        }
        catch {
            fatalError("Error reading password from keychain - \(error)")
        }
        return false

