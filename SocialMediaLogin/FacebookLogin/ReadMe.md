### FB Login

Guide could be followed here: https://developers.facebook.com/docs/swift/login

Sample Code:

import FacebookCore
import FacebookLogin

func viewDidLoad() {    
  // Add a custom login button to your app
  let myLoginButton = UIButton(type: .Custom)]
  myLoginButton.backgroundColor = UIColor.darkGrayColor()
  myLoginButton.frame = CGRect(0, 0, 180, 40);
  myLoginButton.center = view.center;
  myLoginButton.setTitle("My Login Button" forState: .Normal)

  // Handle clicks on the button
  myLoginButton.addTarget(self, action: @selector(self.loginButtonClicked) forControlEvents: .TouchUpInside) 

  // Add the button to the view
  view.addSubview(myLoginButton)
}

// Once the button is clicked, show the login dialog
@objc func loginButtonClicked() {
  let loginManager = LoginManager()
  loginManager.logIn([ .publicProfile ], viewController: self) { loginResult in
    switch loginResult {
    case .Failed(let error): 
      print(error)
    case .Cancelled:
      print("User cancelled login.")
    case .Success(let grantedPermissions, let declinedPermissions, let accessToken):
      print("Logged in!")
  }
}
