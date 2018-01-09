import UIKit
import GoogleMaps

class mapViewXib: GMSMapView{

    @IBOutlet weak var mapView: GMSMapView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("mapViewXib", owner: self, options: nil)
        addSubview(mapView)
        mapView.frame = self.bounds
        mapView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
