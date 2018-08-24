

import MessageUI

class ViewController: UIViewController, MFMailComposeViewControllerDelegate {


    @IBAction func sendEmail(_ sender: UIButton) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            MFMailComposeViewController.canSendMail() == true
            else {
                return
        }
        
        let mailCompose = MFMailComposeViewController()
        mailCompose.mailComposeDelegate = self
        mailCompose.setSubject("Logs for BKG-Test!")
        mailCompose.setMessageBody("", isHTML: false)
        
        let logURLs = appDelegate.fileLogger.logFileManager.sortedLogFilePaths
            .map { URL.init(fileURLWithPath: $0, isDirectory: false) }
        
        var logsDict: [String: Data] = [:] // File Name : Log Data
        logURLs.forEach { (fileUrl) in
            guard let data = try? Data(contentsOf: fileUrl) else { return }
            logsDict[fileUrl.lastPathComponent] = data
        }
        
        for (fileName, logData)  in logsDict {
            mailCompose.addAttachmentData(logData, mimeType: "text/plain", fileName: fileName)
        }
        
        present(mailCompose, animated: true, completion: nil)
    }
    
    
    
    
}
