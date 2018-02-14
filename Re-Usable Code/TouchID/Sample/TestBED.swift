//NEW BUILT

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




//OLD BUILT WITH EMPTY ENTER PASSWORD

    func authenticateUser() {
        let authContext : LAContext = LAContext()
        var error: NSError?
        
        if authContext.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error){
            authContext.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Biometric Check for application", reply: {successful, error -> Void in
                if successful{
                    print("TouchID Yes")
                    self.showAlertController("Touch ID Authentication Succeeded")
                } else {
                    
                    // Check if there is an error
                    if let error = error {
                        let message = self.errorMessageForLAErrorCode(errorCode: error._code)
                        //let message = "\(error)"
                        self.showAlertViewAfterEvaluatingPolicyWithMessage(message: message)
                    }
                }

            }
            )
        }

    }
