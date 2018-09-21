//Changeable color and size

import UIKit

@IBDesignable
class ArchCircle: UIView {
    
    private struct Constants {
        static let lineWidth: CGFloat = 5.0
        static let arcWidth: CGFloat = 30
        
        static var halfOfLineWidth: CGFloat {
            return lineWidth / 2
        }
    }
    
    @IBInspectable var counterColor: UIColor = UIColor.lightGray
    
    override func draw(_ rect: CGRect) {
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let radius: CGFloat = max(bounds.width, bounds.height)
        let startAngle: CGFloat = .pi / 2
        let endAngle: CGFloat = (2 * .pi) + .pi / 2
        let path = UIBezierPath(arcCenter: center,
                                radius: radius/2 - Constants.arcWidth/2,
                                startAngle: startAngle,
                                endAngle: endAngle,
                                clockwise: true)
        
        path.lineWidth = Constants.arcWidth
        counterColor.setStroke()
        path.stroke()
    }
}
