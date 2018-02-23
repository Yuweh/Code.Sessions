//
//  TouchIDLogInPresenter.swift
//  GBA
//
//

import Foundation
import UIKit

protocol DataDidReceivedFromTouchIDLogin{
    func didReceiveVerificationData(code: String)
}

class TouchIDLogInPresenter: EntryRootPresenter {
    var dataBridgeToView: DataDidReceivedFromTouchIDLogin? = nil
    var submittedForm: LoginFormEntity? = nil
    
    func processLogin(form: LoginFormEntity, controller: TouchIDLogInViewController){
        guard let nav = controller.navigationController else { fatalError("NavigationViewController can't properly parsed in LoginPresenter")}
        guard let bridge = dataBridgeToView else { fatalError("dataBridge was not implemented in LoginPresenter") }
        
        self.submittedForm = form
        
        self.interactor.remote.Login(form: form) { (reply, statusCode) in
            print("@Presenter")
            print(form)
            print(reply)
            switch statusCode{
            case .fetchSuccess:
                guard let verifiedStatus = reply["verified"] as? Bool else{
                    return
                }
                
                if verifiedStatus{
                    
                    let authData = UserAuthentication(json: reply)
                    authData.rewrite()
                    
                    switch authData.getGBAAuthLevel{
                    case .oneWay:
                        
                        self.fetchUserProfile(successHandler: { (reply, replyCode) in
                            DashboardWireframe(nav).presentTabBarController()
                        })
                        
                    case .twoWay:
                        self.wireframe.presentCodeVerificationViewController(
                            from: self.view as! GBAVerificationCodeDelegate,
                            completion: {
                                DashboardWireframe(nav).presentTabBarController()
                        }, apiCalls: { (code, vc) in
                            print(code)
                            self.interactor.remote.SubmitLoginVerificationCodes(code: code, accessToken: "String", successHandler: { (reply, replyCode) in
                                print(reply)
                                print(replyCode.rawValue)
                                print(replyCode)
                                
                                switch replyCode{
                                case .forbidden:
                                    self.showAlert(with: "Message", message: "Incorrect or expired verification code", completion: { print(reply) })
                                    
                                case .fetchSuccess:
                                    DashboardWireframe(nav).presentTabBarController()
                                    
                                default:
                                    print(reply)
                                }
                            })
                        }, backAction: {
                            self.view.navigationController?.popToRootViewController(animated: true)
                        })
                    }
                }else{
                    UserAuthentication(json: reply).rewrite()
                    
                    self.wireframe.presentCodeVerificationViewController(from: self.view as! TouchIDLogInViewController,
                                                                         completion:{ ( ) },
                                                                         apiCalls: { (code, view) in
                                                                            print(code)
                                                                            self.interactor.remote.SubmitRegistrationVerificationCode(code: code, to: form.mobile, successHandler: { (reply, replyCode) in
                                                                                
                                                                                print(replyCode)
                                                                                
                                                                                switch replyCode{
                                                                                case .badRequest:
                                                                                    if let message = reply["message"] as? [String: Any],
                                                                                        let code = (message["code"] as? [String])?.first{
                                                                                        self.showAlert(with: "Message", message: code, completion: { print(reply) })
                                                                                    }
                                                                                    view.clearPIN()
                                                                                case .fetchSuccess:
                                                                                    DashboardWireframe(nav).presentTabBarController()
                                                                                default:
                                                                                    print(reply)
                                                                                }
                                                                            })
                    }, backAction: { self.view.navigationController?.popToRootViewController(animated: true) } )
                }
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
                
                self.showAlert(with: "Notice", message: message, completion: { } )
                
                
                
            default: break
            }
            bridge.didReceiveVerificationData(code: String(describing: reply))
        }
    }
    
    func resendVerificationCode(callback: @escaping ()->()){
        self.interactor.remote.ResendLoginVerificationCode { (reply, statusCode) in
            switch statusCode{
            case .fetchSuccess, .accepted:
                callback()
                self.showAlert(with: "Notice", message: "Please check your mobile for verification", completion: { } )
            default: break
            }
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

