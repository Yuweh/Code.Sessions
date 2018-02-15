
// @MainVC


@IBOutlet weak var login_button: GBAButton!

//viewDidLoad()
        self.currentPresenter.countDownTimer != 0 ? 
        self.currentPresenter.checkTryCounter(): ()
        
//func displayCountdown(timer: Int){
        if timer == 0{
            login_button.setTitle("LOGIN", for: .normal)
            login_button.isEnabled = true
            login_button.set(backgroundColor: .primaryBlueGreen)
        }else{
            login_button.setTitle("LOGIN (\(timer))", for: .normal)
            login_button.isEnabled = false
            login_button.set(backgroundColor: .darkGray)
        }
    }

//@ViewPresenter

    var countDownTimer: Int{
        get{ return UserDefaults.standard.integer(forKey: "Countdown") }
        set{ UserDefaults.standard.set(newValue < 0 ? 59: newValue, forKey: "Countdown") }
    }
    private var tryCount = 0
    
    -------> TRIGGER FUNCTION : self.incementTryCount()
    
        
    func checkTryCounter(){
        resetCounter()
    }
    
    fileprivate func incementTryCount(){
        if self.tryCount <= 4{ self.resetCounter() }
        else{ self.tryCount++ }
    }
    
    fileprivate func resetCounter(){
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            self.countDownTimer--
            (self.view as? LoginViewController)?.displayCountdown(timer: self.countDownTimer)
            if self.countDownTimer <= 0{
                (self.view as? LoginViewController)?.displayCountdown(timer: 0)
                self.tryCount = 0
                timer.invalidate()
            }
        })
    }

  
