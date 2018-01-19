
enum Concerns {
    case CannotAccessAccount
    case CannotReload
    case CannotTransferFunds
    
    var name: String{
        switch self{
        case .CannotAccessAccount: return "Cannot Access Account"
        case .CannotReload: return "Cannot Reload"
        case .CannotTransferFunds: return "Cannot Transfer Funds"
        }
    }
    
    var type: String{
        switch self{
        case .CannotAccessAccount: return "1"
        case .CannotReload: return "2"
        case .CannotTransferFunds: return "3"
        }
    }
    
}
