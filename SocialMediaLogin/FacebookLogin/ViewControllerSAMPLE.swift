

import UIKit
import FacebookLogin
import FacebookCore


class FBLoginViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func loginWithFacebook(_ :AnyObject){
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [.publicProfile, .email], viewController: self) { (loginResult) in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                let token = accessToken
                print("Logged in!", token.authenticationToken)
                self.getUserProfile()
            }
        }
    }
    
    func getUserProfile () {
        let connection = GraphRequestConnection()
        connection.add(GraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"], accessToken: AccessToken.current, httpMethod: GraphRequestHTTPMethod(rawValue: "GET")!, apiVersion: "2.8")) { httpResponse, result in
            print("result == ", result)
            switch result {
            case .success(let response):
                print("Graph Request Succeeded: \(response)")
                print("Custom Graph Request Succeeded: \(response)")
                print("My facebook id is \(response.dictionaryValue?["id"])")
                print("My name is \(response.dictionaryValue?["name"])")
                
            case .failed(let error):
                print("Graph Request Failed: \(error)")
            }
        }
        
        connection.start()
    }

    
}
