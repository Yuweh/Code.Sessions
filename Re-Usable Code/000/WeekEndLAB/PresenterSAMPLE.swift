


//PreviousCODE for AccessSettings
    func setDeviceRequest(token: String, uuid: String) {
        guard let bridge = dataBridge else { fatalError("dataBridge was not implemented in AccessSettingsPresenter - set Register Device") }
        self.interactor.remote.setDeviceRequest(uuid: uuid, successHandler: {
            (json, statusCode) in
            print(json)
            
            switch statusCode{
            case .dataCreated, .fetchSuccess:
                
                guard let message = json["message"] as? String else{
                    fatalError("message not found in server reply: [\(json)]")
                }
                
                guard let tmp = json["tmp"] as? [String: Any],
                    let code = tmp["code"] as? String else {
                        print(json)
                        return
                }
                self.showAlert(with: "Notice", message:"The verification code is \(message)", completion: { () })
                bridge.didReceiveResponse(code: "\(message) \(code)")
                
            case .badRequest:
                guard let messages = json["message"] as? [String:Any] else{
                    fatalError("Message not found")
                }
                
                var message: String?
                
                messages.forEach{
                    message = ($0.value as? [String])?.first
                    return
                }
                
                self.showAlert(with: "Message", message: message ?? "message not found", completion: { () })
            default: break
            }
        })
        
        self.wireframe.presentCodeVerificationViewController(
            from: self.view as! GBAVerificationCodeDelegate,
            completion: { }, apiCalls: { code, vc in
            print(code)
            
            self.interactor.remote.setRegisterDevice(token: token, uuid: uuid, code: code, successHandler: {
                (reply, statusCode) in
                print(reply)
                print(statusCode)

                switch statusCode{
                case .dataCreated, .fetchSuccess:
                    guard let message = reply["message"] as? String else{
                        fatalError("message not found in server reply: [\(reply)]")
                    }
                    
                    let messages = NSAttributedString(string: "Thank you for registering this device to your account. You can now connect with anyone through their wallet and move money across the globe real-time.", attributes: [NSAttributedStringKey.font: UIFont(name: "Helvetica Neue", size: GBAText.Size.subContent.rawValue)!])
                    
                    let content = NSMutableAttributedString()
                    content.append(messages)
                    
                    self.wireframe.presentSuccessPage(title: "Device Registered", message: content, doneAction: {
                        //self.wireframe.popToRootViewController(true)
                        self.wireframe.navigate(to: .AccessSettingsMainView)
                    })

                    bridge.didReceiveResponse(code: "\(message)")
                    
                    
                    
                case .unprocessedData:
                    guard let messages = reply["message"] as? [String:Any] else{
                        fatalError("Message not found")
                    }
                    
                    var message: String?
                    
                    messages.forEach{
                        message = ($0.value as? [String])?.first
                        return
                    }
                    self.showAlert(with: "Message", message: message ?? "message not found", completion: { () })
                    
                case .badRequest:
                    guard let messages = reply["message"] as? [String:Any] else{
                        fatalError("Message not found")
                    }
                    
                    var message: String?
                    
                    messages.forEach{
                        message = ($0.value as? [String])?.first
                        return
                    }
                    self.showAlert(with: "Message", message: message ?? "message not found", completion: { () })
                    
                default: break
                }
            })
            
            
        }) {
            self.view.navigationController?.dismiss(animated: true, completion: nil)
        }

    }
    
    func setChangeDevice(token: String, uuid: String){
        
        guard let bridge = dataBridge else { fatalError("dataBridge was not implemented in AccessSettingsPresenter - set Register Device") }
        
        
        self.interactor.remote.setDeviceRequest(uuid: uuid, successHandler: {
            (json, statusCode) in
            print(json)
            
            switch statusCode{
            case .dataCreated, .fetchSuccess:
                
                guard let message = json["message"] as? String else{
                    fatalError("message not found in server reply: [\(json)]")
                }
                
                guard let tmp = json["tmp"] as? [String: Any],
                    let code = tmp["code"] as? String else {
                        print(json)
                        return
                }
                self.showAlert(with: "Notice", message:"The verification code is \(message)", completion: { () })
                bridge.didReceiveResponse(code: "\(message) \(code)")
                
            case .badRequest:
                guard let messages = json["message"] as? [String:Any] else{
                    fatalError("Message not found")
                }
                
                var message: String?
                
                messages.forEach{
                    message = ($0.value as? [String])?.first
                    return
                }
                
                self.showAlert(with: "Message", message: message ?? "message not found", completion: { () })
            default: break
            }
        })
        
        self.wireframe.presentCodeVerificationViewController(
            from: self.view as! GBAVerificationCodeDelegate,
            completion: { }, apiCalls: { code, vc in
                print(code)
                
                self.interactor.remote.setChangeDevice(token: token, uuid: uuid, code: code, successHandler: {
                    (reply, statusCode) in
                    print(reply)
                    print(statusCode)

                    switch statusCode{
                    case .dataCreated, .fetchSuccess:
                        guard let message = reply["message"] as? String else{
                            fatalError("message not found in server reply: [\(reply)]")
                        }
                        
                        let messages = NSAttributedString(string: "Thank you for registering this device to your account. You can now connect with anyone through their wallet and move money across the globe real-time.", attributes: [NSAttributedStringKey.font: UIFont(name: "Helvetica Neue", size: GBAText.Size.subContent.rawValue)!])
                        
                        let content = NSMutableAttributedString()
                        content.append(messages)
                        
                        self.wireframe.presentSuccessPage(title: "Change Register", message: content, doneAction: {
                            //self.wireframe.popToRootViewController(true)
                            self.wireframe.navigate(to: .AccessSettingsMainView)
                        })
                        
                        bridge.didReceiveResponse(code: "\(message)")
                        
                        
                        
                    case .unprocessedData:
                        guard let messages = reply["message"] as? [String:Any] else{
                            fatalError("Message not found")
                        }
                        
                        var message: String?
                        
                        messages.forEach{
                            message = ($0.value as? [String])?.first
                            return
                        }
                        self.showAlert(with: "Message", message: message ?? "message not found", completion: { () })
                        
                    case .badRequest:
                        guard let messages = reply["message"] as? [String:Any] else{
                            fatalError("Message not found")
                        }
                        
                        var message: String?
                        
                        messages.forEach{
                            message = ($0.value as? [String])?.first
                            return
                        }
                        self.showAlert(with: "Message", message: message ?? "message not found", completion: { () })
                        
                    default: break
                    }
                })
                
                
        }) {
            self.view.navigationController?.dismiss(animated: true, completion: nil)
        }
        
    }
    
    func resendVerification(uuid: String) {
        
        guard let bridge = dataBridge else { fatalError("dataBridge was not implemented in AccessSettingsPresenter - set Register Device") }
        
        
        self.interactor.remote.setDeviceRequest(uuid: uuid, successHandler: {
            (json, statusCode) in
            print(json)
            
            switch statusCode{
            case .dataCreated, .fetchSuccess:
                
                self.deleteFirebaseUser()
                guard let message = json["message"] as? String else{
                    fatalError("message not found in server reply: [\(json)]")
                }
                
                guard let tmp = json["tmp"] as? [String: Any],
                    let code = tmp["code"] as? String else {
                        print(json)
                        return
                }
                self.showAlert(with: "Notice", message:"The verification code is \(message)", completion: { () })
                bridge.didReceiveResponse(code: "\(message) \(code)")
                
            case .badRequest:
                guard let messages = json["message"] as? [String:Any] else{
                    fatalError("Message not found")
                }
                
                var message: String?
                
                messages.forEach{
                    message = ($0.value as? [String])?.first
                    return
                }
                
                self.showAlert(with: "Message", message: message ?? "message not found", completion: { () })
            default: break
            }
        })
    }
    
    
    func processVerificationLvl(submittedForm: String){
        self.submittedForm = submittedForm
        guard let bridge = dataBridge else { fatalError("dataBridge was not implemented in AccessSettingsPresenter / Verification Level") }
        print(submittedForm)
        
        self.interactor.remote.submitChangeVerificationLvl(form: submittedForm, successHandler: {
            (reply, statusCode) in
            print(reply)
            print(statusCode)
            
            switch statusCode{
            case .fetchSuccess:
                guard let message = reply["message"] as? String else{
                    fatalError("message not found in server reply: [\(reply)]")
                }
                bridge.didReceiveResponse(code: "\(message)")
                
                
            case .notModified:
                guard let message = reply["message"] as? String else{
                    fatalError("message not found in server reply: [\(reply)]")
                }
                bridge.didReceiveResponse(code: "\(message)")
                
            case .badRequest:
                guard let messages = reply["message"] as? [String:Any] else{
                    fatalError("Message not found")
                }
                
                var message: String?
                
                messages.forEach{
                    message = ($0.value as? [String])?.first
                    return
                }
                self.showAlert(with: "Message", message: message ?? "message not found", completion: { () })
            default: break
            }
        })
    }
}
