//@NetworkManager

fileprivate enum APICalls: Router{
    
    var baseComponent: String { get { return "/public" } }
    
    //Cases
    case resendLoginVerificationCode

    //Router Setup
    var route: Route {
        switch self {
        case .resendLoginVerificationCode:
            return Route(method: .post,
                         suffix: "/auth/resend",
                         parameters: nil,
                         waitUntilFinished: true,
                         nonToken: false)
        }
    }
}

class EntryRemoteInteractor: RootRemoteInteractor{

    func ResendLoginVerificationCode(successHandler: @escaping ((JSON, ServerReplyCode)->Void)){
        NetworkingManager.request(APICalls.resendLoginVerificationCode,
                                  successHandler: successHandler)
    }
}
