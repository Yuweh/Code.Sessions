//
//

import UIKit

protocol DataDidRecievedFromLogin{
    func didRecieveVerificationData(code: String)
}

class LoginPresenter: EntryRootPresenter{
    
    var dataBridgeToView: DataDidRecievedFromLogin? = nil
    var submittedForm: LoginFormEntity? = nil
    
    func processLogin(form: LoginFormEntity, controller: LoginViewController){
        guard let nav = controller.navigationController else { fatalError("NavigationViewController can't properly parsed in LoginPresenter")}
        guard let bridge = dataBridgeToView else { fatalError("dataBridge was not implemented in LoginPresenter") }
        
        self.submittedForm = form
        
        self.interactor.remote.Login(form: form) { (reply, statusCode) in
            print(reply)
            switch statusCode{
            case .fetchSuccess:
                let authData = UserAuthentication(json: reply)
                
                switch authData.getGBAAuthLevel{
                case .oneWay:
                    authData.rewrite()
                    self.fetchUserProfile(successHandler: { (reply, replyCode) in
                        DashboardWireframe(nav).presentTabBarController()
                    })
                    
                case .twoWay:
                    self.wireframe.presentCodeVerificationViewController(
                        from: self.view as! GBAVerificationCodeDelegate,
                        completion: {
                            DashboardWireframe(nav).presentTabBarController()
                    }, apiCalls: { (code, vc) in
                        self.interactor.remote.SubmitLoginVerificationCode(code: code, accessToken: "String", successHandler: { (reply, statusCode) in
                            print(reply)
                            print(statusCode.rawValue)
                        })
                    })
                }
                
            case .forbidden:
                self.wireframe.presentCodeVerificationViewController(from: self.view as! LoginViewController,
                                                                     completion:{
                                                                        ()
                },apiCalls: { (code, view) in
                    self.interactor.remote.SubmitRegistrationVerificationCode(code: code, to: form.mobile, successHandler: { (json, serverReply) in
                        print(serverReply)
                        
                        
                        switch serverReply{
                        case .badRequest:
                            if let message = json["message"] as? [String: Any],
                                let code = (message["code"] as? [String])?.first{
                                self.showAlert(with: "Message", message: code, completion: { print(json) })
                            }
                            view.clearPIN()
                        case .fetchSuccess:
                            DashboardWireframe(nav).presentTabBarController()
                        default:
                            print(json)
                        }
                    })
                })
                
            case .badRequest:
                guard let messages = reply["message"] as? [String:Any] else{
                    fatalError("Message not found")
                }
                
                var message: String?
                
                messages.forEach{
                    message = ($0.value as? [String])?.first
                    return
                }
                
                self.showAlert(with: "Required fields empty", message: message ?? "message not found", completion: { () } )
            case .unauthorized:
                guard let message = reply["message"] as? String else{
                    fatalError("Message not found")
                }
                
                self.showAlert(with: "Notice", message: message, completion: { () } )
            default: break
            }
            bridge.didRecieveVerificationData(code: String(describing: reply))
        }
    }
    
    func resendVerificationCode(){
        guard let number = self.submittedForm?.mobile else {
            fatalError("Mobile number was not set for LoginPresenter")
        }
        self.interactor.remote.ResendVerificationCode(to: number) { (reply, statusCode) in
            guard let code = reply["message"] as? String else{
                fatalError("Verification code not found in \(reply)")
            }
            self.showAlert(with: "Verification Code", message: code, completion: {
                print(code)
            })
        }
    }
    
    func fetchUserProfile(successHandler: @escaping ((JSON, ServerReplyCode)->Void)){
        self.interactor.remote.fetchUserProfile { (reply, replyCode) in
            print(reply)
            
            switch replyCode{
            case .fetchSuccess:
                User(json: reply).rewrite()
                successHandler(reply, replyCode)
            default: break
            }
            
        }
    }
    
    func fetchWallet(successHandler: @escaping (()->Void)){
        self.interactor.remote.fetchWallet { (reply, replyCode) in
            print(reply)
            
            switch replyCode{
            case .fetchSuccess:
                successHandler()
            default: break
            }
        }
    }
    
}

