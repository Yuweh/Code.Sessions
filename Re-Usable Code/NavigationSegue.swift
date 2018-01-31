
//Move to another controller 
       let vc = GBA_MoreViewController(nibName: "GBA_MoreViewController", bundle: nil)
       self.navigationController?.pushViewController(vc, animated: true)

       guard let more = Bundle.main.loadNibNamed("GBA_MoreViewController", owner: self, options: nil)?.first as? GBA_MoreViewController else { fatalError() }
       self.navigationController?.pushViewController(more, animated: true)

       self.navigationController?.popViewController(animated: true)

//Back to previous controller
        @objc private func backBtn_tapped(){
        guard let nav = self.navigationController else { fatalError("NavigationViewController can't properly parsed")}
        nav.dismiss(animated: true, completion: nil)
    }

//OR
self.navigationController?.dismiss(animated: true, completion: nil)
