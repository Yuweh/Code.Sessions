

    weak var timer: Timer?
    var timerDispatchSourceTimer : DispatchSourceTimer?

//MARK: BindingTableStateChecker
extension {
    
    func startBindingTableStateChecker() {
        if #available(iOS 10.0, *) {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
                // *insert repeated func here
                self?.initializeChannel()
                self?.displayPreviouslySelectedActuator()
                self?.tableView.reloadData()
                print("*** start - BindingTableStateChecker()")
            }
        } else {
            // Fallback on earlier versions
            timerDispatchSourceTimer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
            timerDispatchSourceTimer?.scheduleRepeating(deadline: .now(), interval: .seconds(2))
            timerDispatchSourceTimer?.setEventHandler{
                // *insert repeated func here
                self.initializeChannel()
                self.displayPreviouslySelectedActuator()
                self.tableView.reloadData()
                print("*** start - BindingTableStateChecker()")
            }
            timerDispatchSourceTimer?.resume()
        }
    }
    
    func stopBindingTableStateChecker() {
        print("*** stop - BindingTableStateChecker()")
        timer?.invalidate()
        timerDispatchSourceTimer?.cancel()
    }
}
