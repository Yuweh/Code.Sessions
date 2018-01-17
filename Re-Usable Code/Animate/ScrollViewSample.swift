SET With TextView

    /**************************************************************************/
    
    func textViewDidBeginEditing(_ textField: UITextView) {
        self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 250), animated: true)
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        //text == "\n")
        self.message_area.placeholder = ""
        if (text == "\n") {
            message_area.resignFirstResponder()
            self.testRequiredFields()
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            self.scrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
            return false
        }
        return true
    }
    
    /**************************************************************************/

