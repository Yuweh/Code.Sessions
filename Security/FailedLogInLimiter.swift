

//counter
    var failedAttempt = 0
    
//implemented condition

                if self.failedAttempt == 5 {
                    let messages = "Kindly check your Login credentials before trying again"
                     self.showAlert(with: "Login Failed", message: messages, completion: { self.incementTryCount() } )
                    print("Ready for Testing")
                } else {
                    print("Still on process")
                    self.failedAttempt += 1
                    self.showAlert(with: "Notice", message: message, completion: { } )
                    print(self.failedAttempt)
                }

                
