## Code refactored to be compatible with Swift 4
/* Same with https://stackoverflow.com/questions/30089756/rotating-nsstring-in-swift && https://stackoverflow.com/questions/35123856/how-to-set-objects-around-circle-correctly-on-uiview */


import UIKit

@IBDesignable
class GameWheel: UIView {

    var level: Level = Level(questionSet: "ImeeMarcos")
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(ovalIn: rect)
        UIColor.white.setFill()
        path.fill()
        
        //********
        let randomIndex = randomNumber(min: 0, max: UInt32(level.questions.count-1))
        let anagramPair = level.questions[randomIndex]
        let anagram1 = anagramPair[0] as! String
        //********
        
        let center = CGPoint(x: bounds.width/2 , y: bounds.height/2)
        let radius : CGFloat = 100
        let count = 10
        
        var angle = CGFloat(2 * M_PI)
        let step = CGFloat(2 * M_PI) / CGFloat(count)
        
        let circlePath = UIBezierPath(arcCenter: center, radius: radius, startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
        
//        let shapeLayer = CAShapeLayer()
//        shapeLayer.path = circlePath.cgPath
//
//        shapeLayer.fillColor = UIColor.clear.cgColor
//        shapeLayer.strokeColor = UIColor.red.cgColor
//        shapeLayer.lineWidth = 3.0
//
//        self.layer.addSublayer(shapeLayer)
        
        // set objects around circle
        for index in 0..<count {
            let x = cos(angle) * radius + center.x
            let y = sin(angle) * radius + center.y
            
            let label = UILabel()
            label.text = "\(index)"
            label.font = UIFont(name: "Arial", size: 20)
            label.textColor = UIColor.black
            label.sizeToFit()
            label.frame.origin.x = x - label.frame.midX
            label.frame.origin.y = y - label.frame.midY
            
            self.addSubview(label)
            angle += step
        }
        
    }
}
