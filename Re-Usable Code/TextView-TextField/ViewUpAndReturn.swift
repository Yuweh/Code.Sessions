

extension UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.2) {
            self.view.frame = CGRect(x:self.view.frame.origin.x, y:self.view.frame.origin.y - 100, width:self.view.frame.size.width, height:self.view.frame.size.height)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.2) {
            self.view.frame = CGRect(x:self.view.frame.origin.x, y:self.view.frame.origin.y + 100, width:self.view.frame.size.width, height:self.view.frame.size.height)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
