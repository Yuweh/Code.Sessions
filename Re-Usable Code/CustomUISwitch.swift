

    @IBAction func didTapVerificationCode(_ sender: UISwitch) {
        if switchVerificationCode.isOn {
            print("switchVerificationCode.isOn")
            self.selectedVerificationLvl = "2"
            self.verificationState.text = "2"
            self.showSettingChangesAlert()
        } else {
            print("switchVerificationCode.isOff")
            self.selectedVerificationLvl = "1"
            self.verificationState.text = "1"
            self.showSettingChangesAlert()
        }
    }
