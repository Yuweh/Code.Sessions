
// Keychain Configuration
struct KeychainConfiguration {
  static let serviceName = "TouchMeIn"
  static let accessGroup: String? = nil
}

    
    
    // 5. Write-Up to Save Item @KeychainWrapper
    do {
      // This is a new account, create a new keychain item with the account name.
      let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                              account: newAccountName,
                                              accessGroup: KeychainConfiguration.accessGroup)
        
      // Save the password for the new item.
      try passwordItem.savePassword(newPassword)
    } catch {
      fatalError("Error updating keychain - \(error)")
    }


//func: 

func checkLogin(username: String, password: String) -> Bool {
  guard username == UserDefaults.standard.value(forKey: "username") as? String else {
    return false
  }
    
  do {
    let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                            account: username,
                                            accessGroup: KeychainConfiguration.accessGroup)
    let keychainPassword = try passwordItem.readPassword()
    return password == keychainPassword
  } catch {
    fatalError("Error reading password from keychain - \(error)")
  }
}
