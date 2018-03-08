
    @objc override func backBtn_tapped(){

        guard let nav = self.navigationController else { fatalError("NavigationViewController can't properly parsed")}
        nav.dismiss(animated: true, completion: nil)
        
        // Option 1
        //self.currentPresenter.wireframe.dismiss(true)
        //self.currentPresenter.wireframe.popViewController(animated: true)
        
        // Option 2
        //self.navigationController?.popViewController(animated: true)
        //self.navigationController?.dismiss(animated: true, completion: nil)
        
        // Option 3
        //guard let navController = self.navigationController else { return }
        //SettingsWireframe(navController).dismiss(true)
        //SettingsWireframe(navController).popViewController(animated: true)
        
        // Option 4
        guard let nav = self.navigationController else { fatalError("NavigationViewController can't properly parsed")}
        nav.dismiss(animated: true, completion: nil)
    }
