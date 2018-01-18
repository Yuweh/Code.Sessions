
This code allows customization of usual uiElements like UITextView or TextField

//***********************************************************************************

import UIKit

class GBARootFocusableObject: UIView{
    
}


//***********************************************************************************

import UIKit

enum GBATextFieldInputType{
    case freeText
    case mobileNumber
}

class GBATextField: GBARootFocusableObject, UITextFieldDelegate{
    
    fileprivate var _textField: UITextField!
    
    fileprivate var maxLength: Int?
    fileprivate var inputType: GBATextFieldInputType = .freeText{
        didSet{
            
            switch inputType {
            case .freeText:
                self._textField.keyboardType = .default
            case .mobileNumber:
                self._textField.keyboardType = .numberPad
            }
        }
    }
    
    var delegate: GBAFocusableInputViewDelegate? = nil
    
    fileprivate(set) var placeholder: String = ""{
        didSet{
            self._textField.placeholder = self.placeholder
        }
    }
    
    fileprivate(set) var text: String = ""{
        didSet{
            self._textField.text = self.text
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let view = UIView()
        let underLineView = UIView()
        self._textField = UITextField()
            .set(font: GBAText.Font.main(GBAText.Size.subContent.rawValue).rawValue
        )
        
        self.isUserInteractionEnabled = true
        self.backgroundColor = .clear
        self.clipsToBounds = true
        
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        underLineView.backgroundColor = GBAColor.gray.rawValue
        underLineView.translatesAutoresizingMaskIntoConstraints = false
        
        self._textField.borderStyle = .none
        self._textField.backgroundColor = .clear
        self._textField.textColor = GBAColor.darkGray.rawValue
        self._textField.translatesAutoresizingMaskIntoConstraints = false
        self._textField.addTarget(self, action: #selector(textDidChanged), for: .editingChanged)
        self._textField.delegate = self
        
        self.insertSubview(view, at: 1)
        self.insertSubview(underLineView, at: 2)
        view.insertSubview(_textField, at: 0)
        
        view.topAnchor.constraint(equalTo: self.topAnchor).Enable()
        view.leadingAnchor.constraint(equalTo: self.leadingAnchor).Enable()
        view.trailingAnchor.constraint(equalTo: self.trailingAnchor).Enable()
        
        underLineView.topAnchor.constraint(equalTo: view.bottomAnchor).Enable()
        underLineView.leadingAnchor.constraint(equalTo: self.leadingAnchor).Enable()
        underLineView.trailingAnchor.constraint(equalTo: self.trailingAnchor).Enable()
        underLineView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -14).Enable()
        underLineView.heightAnchor.constraint(equalToConstant: 1).Enable()
        
        _textField.topAnchor.constraint(equalTo: view.topAnchor).Enable()
        _textField.leadingAnchor.constraint(equalTo: view.leadingAnchor).Enable()
        _textField.trailingAnchor.constraint(equalTo: view.trailingAnchor).Enable()
        _textField.bottomAnchor.constraint(equalTo: view.bottomAnchor).Enable()
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if self.inputType == .mobileNumber && textField.text == ""{
            self.set(text: "+")
        }
        
        guard let del = delegate else { fatalError("Delegate was not set for GBATextField") }
        del.GBAFocusableInput(view: self)
        return true
    }
    
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if self.inputType == .mobileNumber && textField.text == "+"{ self.set(text: "") }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if self._textField.returnKeyType != .next{
            return textField.resignFirstResponder()
        }
        
        self._textField.resignFirstResponder()
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if self.inputType == .mobileNumber && textField.text == "+" && string == ""{
            return false
        }
        
        guard let length = self.maxLength,
            let currentString = self._textField.text as NSString?
        else { return true }
        
        return currentString.length < length
    }
    
    @objc private func textDidChanged(_ textField: UITextField){
        self.set(text: self._textField.text!)
    }
    
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        return _textField.becomeFirstResponder()
    }
}


extension GBATextField{
    @discardableResult
    func set(placeholder: String)->Self{
        self.placeholder = placeholder
        return self
    }
    
    @discardableResult
    func set(text: String)->Self{
        self.text = text
        return self
    }
    
    @discardableResult
    func set(alignment: NSTextAlignment)->Self{
        self._textField.textAlignment = alignment
        return self
    }
    
    @discardableResult
    func set(keyboardType: UIKeyboardType)->Self{
        self._textField.keyboardType = keyboardType
        return self
    }
    
    @discardableResult
    func set(inputType: GBATextFieldInputType)->Self{
        self.inputType = inputType
        
        switch self.inputType{
        case .freeText:
            self.set(keyboardType: .default)
        case .mobileNumber:
            self.set(keyboardType: .numberPad)
        }
        
        return self
    }
    
    @discardableResult
    func set(textColor: GBAColor)->Self{
        self._textField.textColor = textColor.rawValue
        return self
    }
    
    @discardableResult
    func set(security: Bool)->Self{
        self._textField.isSecureTextEntry = security
        return self
    }
    
    @discardableResult
    func set(max characterLength: Int)->Self{
        self.maxLength = characterLength
        return self
    }
    
    @discardableResult
    func set(_ delegate: GBAFocusableInputViewDelegate)->Self{
        self.delegate = delegate
        return self
    }
    
    @discardableResult
    func set(returnKeyType: UIReturnKeyType)->Self{
        self._textField.returnKeyType = returnKeyType
        return self
    }
}

