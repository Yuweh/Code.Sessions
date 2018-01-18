//

import UIKit
import FontAwesome_swift

class GBAConcernCellView: UITableViewCell{
    private let _view: UIView = UIView()
    var concernLabel: UILabel = UILabel()
    //fileprivate(set) var concern: Countries = .Philippines
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        
        self.addSubview(concernLabel)
        self.addSubview(_view)
        
        self._view.topAnchor.constraint(equalTo: self.topAnchor).Enable()
        self._view.leadingAnchor.constraint(equalTo: self.leadingAnchor).Enable()
        self._view.trailingAnchor.constraint(equalTo: self.trailingAnchor).Enable()
        self._view.bottomAnchor.constraint(equalTo: self.bottomAnchor).Enable()

        self.concernLabel.topAnchor.constraint(equalTo: self._view.topAnchor).Enable()
        self.concernLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).Enable()
        self.concernLabel.bottomAnchor.constraint(equalTo: self._view.bottomAnchor).Enable()
        self.concernLabel.trailingAnchor.constraint(equalTo: self._view.trailingAnchor).Enable()
    }
    
    
    //

enum Concerns {

    case CannotAccessAccount
    case CannotReload
    case CannotTransferFunds
    
    var type: String{
        switch self{
        case .CannotAccessAccount: return "1"
        case .CannotReload: return "2"
        case .CannotTransferFunds: return "3"
        default : return "0"
        }
    }
    
    var name: String{
        switch self {
        case .CannotAccessAccount: return "Cannot Access Account"
        case .CannotReload: return "Cannot Reload"
        case .CannotTransferFunds: return "Cannot Transfer Funds"
        default : return "default"
        }
    }
    
}
