//APP DELEGATE - APPLICATION

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
    UIApplication.shared.setMinimumBackgroundFetchInterval(
      UIApplicationBackgroundFetchIntervalMinimum)
    
    return true
  }
  
  // Support for background fetch
  func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    if let tabBarController = window?.rootViewController as? UITabBarController,
           let viewControllers = tabBarController.viewControllers
    {
      for viewController in viewControllers {
        if let fetchViewController = viewController as? FetchViewController {
          fetchViewController.fetch {
            fetchViewController.updateUI()
            completionHandler(.newData)
          }
        }
      }
    }
  }
}





//TEST VC - APPLICATION

import UIKit

class FetchViewController: UIViewController {
  
  @IBOutlet var updateLabel: UILabel!
  
  private var time: Date?
  private lazy var dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .long
    return formatter
  }()
  
  func fetch(_ completion: () -> Void) {
    time = Date()
    completion()
  }
  
  func updateUI() {
    guard updateLabel != nil  else {
      return
    }
    
    if let time = time {
      updateLabel.text = dateFormatter.string(from: time)
    } else {
      updateLabel.text = "Not yet updated"
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    updateUI()
  }
  
  @IBAction func didTapUpdate(_ sender: UIButton) {
    fetch { [weak self] in
      guard let strongSelf = self else { return }
      strongSelf.updateUI()
    }
  }
}
