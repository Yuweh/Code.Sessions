

import UIKit
import CoreData


// Keychain Configuration
struct KeychainConfiguration {
  static let serviceName = "TouchMeIn"
  static let accessGroup: String? = nil
}
class LoginViewController: UIViewController {

  // MARK: Properties
  var managedObjectContext: NSManagedObjectContext?
  //let usernameKey = "Batman"
  //let passwordKey = "Hello Bruce!"
  
  var passwordItems: [KeychainPasswordItem] = []
  let createLoginButtonTag = 0
  let loginButtonTag = 1
  
  @IBOutlet weak var loginButton: UIButton!

  // MARK: - IBOutlets
  @IBOutlet weak var usernameTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var createInfoLabel: UILabel!  

  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // 1
    let hasLogin = UserDefaults.standard.bool(forKey: "hasLoginKey")
    
    // 2
    if hasLogin {
      loginButton.setTitle("Login", for: .normal)
      loginButton.tag = loginButtonTag
      createInfoLabel.isHidden = true
    } else {
      loginButton.setTitle("Create", for: .normal)
      loginButton.tag = createLoginButtonTag
      createInfoLabel.isHidden = false
    }
    
    // 3
    if let storedUsername = UserDefaults.standard.value(forKey: "username") as? String {
      usernameTextField.text = storedUsername
    }
    
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
}

// MARK: - IBActions
extension LoginViewController {

  @IBAction func loginAction(sender: Any) {
    // 1
    // Check that text has been entered into both the username and password fields.
    guard let newAccountName = usernameTextField.text,
      let newPassword = passwordTextField.text,
      !newAccountName.isEmpty,
      !newPassword.isEmpty else {
        showLoginFailedAlert()
        return
    }
    
    // 2
    usernameTextField.resignFirstResponder()
    passwordTextField.resignFirstResponder()
    
    // 3
    if (sender as AnyObject).tag == createLoginButtonTag {
      // 4
      let hasLoginKey = UserDefaults.standard.bool(forKey: "hasLoginKey")
      if !hasLoginKey && usernameTextField.hasText {
        UserDefaults.standard.setValue(usernameTextField.text, forKey: "username")
      }
      
      // 5
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
      
      // 6
      UserDefaults.standard.set(true, forKey: "hasLoginKey")
      loginButton.tag = loginButtonTag
      performSegue(withIdentifier: "dismissLogin", sender: self)
    } else if (sender as AnyObject).tag == loginButtonTag {
      // 7
      if checkLogin(username: newAccountName, password: newPassword) {
        performSegue(withIdentifier: "dismissLogin", sender: self)
      } else {
        // 8
        showLoginFailedAlert()
      }
    }
  }
    
  //performSegue(withIdentifier: "dismissLogin", sender: self)
  
  
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
  
  private func showLoginFailedAlert() {
    let alertView = UIAlertController(title: "Login Problem",
                                      message: "Wrong username or password.",
                                      preferredStyle:. alert)
    let okAction = UIAlertAction(title: "Foiled Again!", style: .default)
    alertView.addAction(okAction)
    present(alertView, animated: true)
  }
}
