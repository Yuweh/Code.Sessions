//******************************************************

//
class ManagePayeesRootPresenter: RootPresenter{
    
    var wireframe: ManagePayeesWireframe
    var view: ManagePayeesModuleViewController
    var interactor: (local: RootLocalInteractor, remote: ManagePayeesRemoteInteractor) = (RootLocalInteractor(), ManagePayeesRemoteInteractor())
    
    init(wireframe: ManagePayeesWireframe, view: ManagePayeesModuleViewController){
        self.wireframe = wireframe
        self.view = view
    }

    func set(view: ManagePayeesModuleViewController){
        self.view = view
    }
    
    func showAlert(with title: String?, message: String, completion: @escaping (()->Void)){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.view.present(alert, animated: true, completion: nil)
        
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
            alert.dismiss(animated: true, completion: completion)
        }
    }
    
   //******************************************************

//
    
    
//  ManagePayeesRemoteInteractor.swift
import Foundation

fileprivate enum APICalls: Router{

    case sendCheckPayee(mobile: String)
    
    var baseComponent: String { get { return "/public" } }

    //Cases

    var route: Route {
        switch self {
        case .sendCheckPayee(let mobile):
            return Route(method: .post, suffix: "/payee/check", parameters: ["mobilenumber" : mobile], waitUntilFinished: true)
        }
    }
    //Router Setup
}

class ManagePayeesRemoteInteractor: RootRemoteInteractor{
    
    // Contact Support API Calls
    
    func SubmitCheckPayeeForm(form: CheckPayeeEntity, successHandler: @escaping ((JSON, ServerReplyCode)->Void)){
        NetworkingManager.request(APICalls.sendCheckPayee(mobile: form.mobile!),
                                  successHandler: {
                                    (reply, statusCode) in
                                    successHandler(reply, statusCode)
        })
    
        
            
   //******************************************************

//
    







