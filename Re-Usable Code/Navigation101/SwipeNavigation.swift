
//
        let swipeGesture:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(showLuggageMenu(_:)))
        swipeGesture.direction = .right
        swipeGesture.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(swipeGesture)

    @objc func showLuggageMenu(_ sender: Any) {
        let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "LuggageMenuViewController")
        self.transitionLayer.isHidden = false
        let transition = CATransition()
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.transitionLayer.window?.layer.add(transition, forKey: kCATransition)
        self.present(newViewController!, animated: false, completion: nil)
        Logger.log("SWIPE WORKING")
    }


class FirstSceneViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let swipeGesture:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(dismissVC(_:)))
        swipeGesture.direction = .right
        swipeGesture.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(swipeGesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func dismissVC(_ sender: Any) {
        let transition = CATransition()
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        self.view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false, completion: nil)
    }

}
