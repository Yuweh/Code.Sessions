
    @IBAction func selectImageForProfilePicture(_ sender: UITapGestureRecognizer) {
        self.bottomActionSheetPressed()
        print("*** selectImage Tapped ***")
    }
    
        //MARK: Bottom ActionSheet
    
    func bottomActionSheetPressed() {
        let alert = UIAlertController(title: nil, message: "Select image for your profile photo", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Select from gallery", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.selectFromGallery()}))
        alert.addAction(UIAlertAction(title: "Capture an image", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.getAnImage()}))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //functions for the ActionSheet could be seen at PhotoLibrary
    
    
