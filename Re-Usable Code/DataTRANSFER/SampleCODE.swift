    //data holder for all steps
    var payee: Payee? = nil
    var sourceAccount: Wallet? = nil
    var transferAmount: Double = 0.00
    var transferDate: String? = nil
    
    //  PaySomeoneRecipentViewController for " var payee "
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentPresenter.payee = payeeList[indexPath.row]
        currentPresenter.didEditForm = true
        
        self.presenter.wireframe.navigate(to: .PaySomeoneSourceAccountView, with: self.currentPresenter)
    }
    
    //  PaySomeoneSourceAccountViewController for " var sourceAccount "
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let wallet = walletList[indexPath.row]
        currentPresenter.sourceAccount = wallet
        currentPresenter.didEditForm = true
        
        self.presenter.wireframe.navigate(to: .PaySomeoneAmountView, with: self.currentPresenter)
    }
    
    
    //  PaySomeoneAmountViewController for " var transferAmount "
                if (currentBalance >= transferAmount!){
                currentPresenter.transferAmount = transferAmount!
                currentPresenter.didEditForm = true
                self.presenter.wireframe.navigate(to: .PaySomeoneTransferScheduleView, with: self.currentPresenter)
                
                
      //  PaySomeoneTransferScheduleViewController for " var transferAmount "
      
          @objc func tempNextButton() {
        currentPresenter.transferDate = self.lblDateSelected.text
        
        self.presenter.wireframe.navigate(to: .PaySomeoneTransactionSummaryView, with: self.currentPresenter)
    }
    
    
      
      
      
      
      
      
      
      
      
      
      
