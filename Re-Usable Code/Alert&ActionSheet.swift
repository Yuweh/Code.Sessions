
//MARK: In APPDELEGATE (regardless of VC)    

    @objc func localModeAlertBox() {
        print("*** localModeAlertBox SHOWN for LocalGatewayManager")
        let alert = UIAlertController(title: "", message:"You have been disconnected from our server. \n\nDo you to proceed to Local Mode?", preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "config_common_js_no".localized, style: UIAlertActionStyle.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "config_common_js_yes".localized, style: UIAlertActionStyle.destructive, handler: nil))
        
        // show alert
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindowLevelAlert + 1;
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(alert, animated: true, completion: nil)
    }



//MARK: ActionSheet SAMPLE
    
    func bottomActionSheetPressed() {
        let alert = UIAlertController(title: nil, message: "Get an image of your check", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Select from Gallery", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.selectFromGallery()}))
        alert.addAction(UIAlertAction(title: "Capture an image", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.getAnImage()}))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // Alert SAMPLE
    func cancelAlertAction() {
        let alert = UIAlertController(title: "Cancel Transaction?", message: "This transaction will not be saved", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.transactionWasCancelled()}))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
