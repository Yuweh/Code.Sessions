//Example of Calling
KeychainService.savePassword("Pa55worD")
let password = KeychainService.loadPassword() // password = "Pa55worD"



//You need to imagine the following wired up to a text input field and a label, then having four buttons wired up, one for each of the methods.

class ViewController: NSViewController {
    @IBOutlet weak var enterPassword: NSTextField!
    @IBOutlet weak var retrievedPassword: NSTextField!

    let service = "myService"
    let account = "myAccount"

    // will only work after
    @IBAction func updatePassword(_ sender: Any) {
        KeychainService.updatePassword(service: service, account: account, data: enterPassword.stringValue)
    }

    @IBAction func removePassword(_ sender: Any) {
        KeychainService.removePassword(service: service, account: account)
    }

    @IBAction func passwordSet(_ sender: Any) {
        let password = enterPassword.stringValue
        KeychainService.savePassword(service: service, account: account, data: password)
    }

    @IBAction func passwordGet(_ sender: Any) {
        if let str = KeychainService.loadPassword(service: service, account: account) {
            retrievedPassword.stringValue = str
        }
        else {retrievedPassword.stringValue = "Password does not exist" }
    }
}
