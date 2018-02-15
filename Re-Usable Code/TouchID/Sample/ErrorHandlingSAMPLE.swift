




//RayWenderlich for iOS 11

        let message: String

        switch evaluateError {
        case LAError.authenticationFailed?:
          message = "There was a problem verifying your identity."
        case LAError.userCancel?:
          message = "You pressed cancel."
        case LAError.userFallback?:
          message = "You pressed password."
        case LAError.biometryNotAvailable?:
          message = "Face ID/Touch ID is not available."
        case LAError.biometryNotEnrolled?:
          message = "Face ID/Touch ID is not set up."
        case LAError.biometryLockout?:
          message = "Face ID/Touch ID is locked."
        default:
          message = "Face ID/Touch ID may not be configured"
        }
        completion(message)  


//Error Messages:
#updated for iOS 11 

                    let message: String
                    
                    switch evaluateError {
                    case LAError.appCancel?:
                        message = "Authentication was cancelled by application"
                        
                    case LAError.authenticationFailed?:
                        message = "The user failed to provide valid credentials"
                        
                    case LAError.invalidContext?:
                        message = "The context is invalid"
                        
                    case LAError.passcodeNotSet?:
                        message = "Passcode is not set on the device"
                        
                    case LAError.systemCancel?:
                        message = "Authentication was cancelled by the system"
                        
                    case LAError.touchIDLockout?:
                        message = "Too many failed attempts."
                        
                    case LAError.touchIDNotAvailable?:
                        message = "TouchID is not available on the device"
                        
                    case LAError.userCancel?:
                        message = "The user did cancel"
                        
                    case LAError.userFallback?:
                        message = "The user chose to use the fallback"
                    default:
                        message = "Face ID/Touch ID may not be configured"




#updated for iOS 11 with errorCode

    func errorMessageForLAErrorCode(errorCode:Int) -> String{
        
        var message = ""
        
        switch errorCode {
            
        case LAError.appCancel.rawValue:
            message = "Authentication was cancelled by application"
            
        case LAError.authenticationFailed.rawValue:
            message = "The user failed to provide valid credentials"
            
        case LAError.invalidContext.rawValue:
            message = "The context is invalid"
            
        case LAError.passcodeNotSet.rawValue:
            message = "Passcode is not set on the device"
            
        case LAError.systemCancel.rawValue:
            message = "Authentication was cancelled by the system"
            
        case LAError.touchIDLockout.rawValue:
            message = "Too many failed attempts."
            
        case LAError.touchIDNotAvailable.rawValue:
            message = "TouchID is not available on the device"
            
        case LAError.userCancel.rawValue:
            message = "The user did cancel"
            
        case LAError.userFallback.rawValue:
            message = "The user chose to use the fallback"
            
        default:
            message = "Did not find error code on LAError object"
            
        }
        
        return message

