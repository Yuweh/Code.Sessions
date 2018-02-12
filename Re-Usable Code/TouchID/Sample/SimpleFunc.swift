 @IBAction func action(_ sender: Any) {
        authenticateUser()
 }

func authenticateUser() {
    let authContext : LAContext = LAContext()
    var error: NSError?

    if authContext.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error){
        authContext.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Biometric Check for application", reply: {successful, error -> Void in
            if successful{
                print("TouchID Yes")
            }
            else{
                print("TouchID No")
            }
        }
        )
    }
    else{
        authContext.evaluatePolicy(LAPolicy.deviceOwnerAuthentication, localizedReason: "Enter your Passcode", reply: {
            successful,error in
            if successful{
                print("PassCode Yes")
            }
            else{
                print("PassCode No")
            }
        }
        )
    }
}
