//
//  ViewController.swift
//  Test
//
//  Created by Chen Wu on 11/1/16.
//  Copyright © 2016 test. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var timer: Timer!

    @IBOutlet weak var replicator: MOJOReplicatorView!
//    @IBOutlet weak var replicator2: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        replicator.setup()
        
    }
    
    @IBAction func pressed(_ sender: Any) {
        
        if (sender as! UIButton).titleLabel?.text == "Start" {
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: replicator, selector: #selector(MOJOReplicatorView.animate as (MOJOReplicatorView) -> () -> ()), userInfo: nil, repeats: true)
            (sender as! UIButton).setTitle("Stop", for: .normal)
        } else {
            timer.invalidate()
            (sender as! UIButton).setTitle("Start", for: .normal)
        }

    }

    @IBAction func heli(_ sender: Any) {
        let button = sender as! UIButton
        
        if button.titleLabel?.text == "Start" {
            button.setTitle("lol", for: .normal)
            replicator.animateHeli()
        }else {
            replicator.changeHeli()
        }
        
    }
}

class MOJOReplicatorView: UIView {
    
    var replicator : MOJOReplicatorLayer!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    lazy var thickLine: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = CGRect(x: self.bounds.size.width / 2.0, y: 0, width: 1, height: self.bounds.size.height)
        shapeLayer.lineCap = kCALineCapRound
        shapeLayer.lineWidth = 3.0
        shapeLayer.strokeColor = UIColor(hex: 0x7D96A7, alpha: 1).cgColor
        shapeLayer.opacity = 0.7
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: self.bounds.size.width / 2.0, y: 0))
        path.addLine(to: CGPoint(x: self.bounds.size.width / 2.0, y: self.bounds.size.height / 4.0))
        shapeLayer.path = path.cgPath
        
        return shapeLayer
    }()
    
    lazy var thinLine: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        let newY = self.bounds.size.height/4/4
        shapeLayer.frame = CGRect(x: self.bounds.size.width / 2.0, y: newY, width: 1, height: self.bounds.size.height)
        shapeLayer.lineCap = kCALineCapRound
        shapeLayer.lineWidth = 1.0
        shapeLayer.strokeColor = UIColor(hex: 0x7D96A7, alpha: 1).cgColor
        shapeLayer.opacity = 0.7
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: self.bounds.size.width / 2.0, y: newY))
        path.addLine(to: CGPoint(x: self.bounds.size.width / 2.0, y: self.bounds.size.height / 4.0))
        shapeLayer.path = path.cgPath
        
        return shapeLayer
    }()

    let image = UIImageView(image: #imageLiteral(resourceName: "arrow"))
    
    func setup()
    {
        print(self.frame)
        print(self.bounds)

        

        
        // 2. Configure a replicator with the shape layer we just set up, and tell it how many copies to make
        replicator = MOJOReplicatorLayer()
        replicator.frame = self.bounds
        replicator.instanceShape = thinLine
        replicator.instanceShapeBig = thickLine
        replicator.instanceCount = 68
        
        
        // 3. Attach our replicator as a sublayer
        self.layer.addSublayer(replicator)
        
        let size = #imageLiteral(resourceName: "arrow").size
        image.frame = CGRect(x: self.bounds.width/2, y: 0, width: size.width, height: size.height)
        //        image.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        image.backgroundColor = UIColor.black
        self.addSubview(image)
    }
    var index = 0;
    
    func animate()
    {
        let lineWidthAnimation = CABasicAnimation(keyPath: "lineWidth")
        lineWidthAnimation.duration = 0.15
        lineWidthAnimation.fromValue = replicator.instanceLayers[Int(0)].lineWidth
        lineWidthAnimation.toValue = replicator.instanceLayers[Int(0)].lineWidth * 3.0
        lineWidthAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        lineWidthAnimation.autoreverses = true
        
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.duration = 0.15
        opacityAnimation.fromValue = 0.7
        opacityAnimation.toValue = 1.0
        opacityAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        opacityAnimation.autoreverses = true
        
        let strokeColorAnimation = CABasicAnimation(keyPath: "strokeColor")
        strokeColorAnimation.duration = 0.15
        strokeColorAnimation.toValue = UIColor(hex: 0xFFA5A9, alpha: 1).cgColor
        strokeColorAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        // 2. Group the animations into an animation group
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 0.3
        animationGroup.animations = [lineWidthAnimation, opacityAnimation, strokeColorAnimation]
        
        // 3. Retrieve our replicator's layer count, and generate a random value within its range
        let count = UInt32(replicator.instanceLayers.count)
        let rand = arc4random() % count
        
        // 4. Add the animation group to our randomly selected layer
        let z = replicator.instanceLayers[index]
        z.strokeColor = UIColor(hex: 0xFFA5A9, alpha: 1).cgColor
        replicator.instanceLayers[index].add(animationGroup, forKey: nil)
        index = (index+1) % Int(count)
    }
    
    var speed:Float = 1
    var redLine = CAShapeLayer()
    func animateHeli() {
        //////////////////////////////////////
        print(self.bounds)

        let keyframe = CAKeyframeAnimation(keyPath: "position")
        keyframe.duration = 3
        keyframe.repeatCount = 0
        keyframe.speed = speed
        speed *= -1
        let circularPath = CGMutablePath()
        let x = self.bounds.width / 2
        let y = (self.bounds.height/2)
        let center = CGPoint(x: x, y: y)
        
//        (speed == 1 ? true : false)
        circularPath.addArc(center: center, radius: self.bounds.width/2, startAngle: CGFloat(M_PI), endAngle: CGFloat((2*M_PI)+M_PI), clockwise: false)
//        keyframe.speed = -1
        keyframe.path = circularPath
        
//        keyframe.calculationMode = kCAAnimationPaced
        keyframe.rotationMode = kCAAnimationRotateAuto
        
        image.layer.add(keyframe, forKey: "zzz")

        redLine = CAShapeLayer()
        redLine.path = circularPath
        redLine.fillColor = UIColor.clear.cgColor
        redLine.strokeColor = UIColor.red.cgColor
        redLine.lineWidth = 3.0
        self.layer.addSublayer(redLine)
        
        self.bringSubview(toFront: image)
    }
    
    func convertToProperRadians(radians: CGFloat) -> CGFloat {
        if radians > 0 { return radians }
        return CGFloat(M_PI) +  (CGFloat(M_PI)-abs(radians))
    }
    
    func changeHeli() {
//        image.layer.removeAnimation(forKey: "zzz")
        let position = image.layer.presentation()!.position
        let x2 = position.x
        let y2 = position.y
        let x = self.bounds.width / 2
        let y = (self.bounds.height/2)
        
        var v = atan2((y2-y), (x2-x))
        v = convertToProperRadians(radians: v)
//        print((y2-y), (x2-x))
//        print(v)
//        print((v*180)/(.pi))
//        let top = position.y -
//        print(image.layer.presentation()?.animation(forKey: "zzz"))
//        print(newX, newY)
//        print(image.layer.presentation()!.position)
        
        
        let center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height/2)
        
        let randomAngle = arc4random() % 360
        var randomRadian = CGFloat(randomAngle).radiansValue
//        print(randomRadian)
        
        
        var absolute = v.degreesValue - CGFloat(randomAngle)
        print(v.degreesValue, randomAngle, absolute)
        
        let practiceStart: CGFloat = 270
        let practiceEnd: CGFloat = 70
        absolute = practiceStart - practiceEnd
        v = CGFloat(270).radiansValue
        randomRadian = CGFloat(257).radiansValue
//        let smaller = practiceStart < practiceEnd ? practiceStart : practiceEnd
//        let bigger = practiceStart < practiceEnd ? practiceEnd : practiceStart
//        let diff = bigger - smaller
        let rawDiff = fabs(practiceStart-practiceEnd)
        let subtract = fmod(rawDiff, 360)
        let final = 180 - fabs(subtract-180)
        print(final)
        
        var clockwise = true
        if fmod((randomRadian.degreesValue - v.degreesValue + 360), 360) < 180 {
            clockwise = true
        }
        else {
            clockwise = false
        }

        
        let circularPath = UIBezierPath(arcCenter: center, radius: self.bounds.width/2, startAngle: v, endAngle: randomRadian, clockwise: clockwise)
//        circularPath.addArc(center: center, radius: self.bounds.width/2, startAngle: practiceStart.radiansValue, endAngle: practiceEnd.radiansValue, clockwise: false)
        
//        circularPath.adde
        let keyframe = CAKeyframeAnimation(keyPath: "position")
//        keyframe.speed = speed
//        speed *= -1
        keyframe.speed = 1
        keyframe.duration = 1
        keyframe.path = circularPath.cgPath
        
        keyframe.calculationMode = kCAAnimationPaced
//        keyframe.rotationMode = kCAAnimationRotateAuto
        // -1 is clockwise 1 is counter
        
        let nX = center.x + self.bounds.width/2 * cos(randomRadian)
        let nY = center.y + self.bounds.width/2 * sin(randomRadian)
        print("compare:")
        image.layer.position = CGPoint(x: nX, y: nY)
        image.layer.add(keyframe, forKey: "zzz")
        
        redLine.removeFromSuperlayer()
        redLine = CAShapeLayer()
        redLine.path = circularPath.cgPath
        redLine.fillColor = UIColor.clear.cgColor
        redLine.strokeColor = UIColor.red.cgColor
        redLine.lineWidth = 3.0
        self.layer.insertSublayer(redLine, below: image.layer)

        return
    }
}

extension CGFloat {
    var radiansValue: CGFloat {
        return self*(.pi)/180
    }
    
    var degreesValue: CGFloat {
        return (self*180)/(.pi)
    }
}

class MOJOReplicatorLayer: CALayer {
    
    var instanceShape : CAShapeLayer!
    
    var instanceShapeBig : CAShapeLayer!
    
    var instanceCount : Int = 4 {
        didSet {
            updateLayers()
        }
    }
    
    var instanceLayers = [CAShapeLayer]()
    
    func updateLayers()
    {
        // 1. Check if we have an existing set of replicated sublayers, zap it (along with the contents of the instanceLayers array) if we do
        if self.sublayers != nil {
            self.sublayers?.removeAll(keepingCapacity: false)
            self.instanceLayers.removeAll(keepingCapacity: false)
        }
        
        // 2. Calculate a rotation angle based on instanceCount
        var angle = Float(M_PI * 2.0) / Float(instanceCount)
        // 3. Create a sublayer for each instance
        for index in 0...self.instanceCount-1 {
            // configure a new shape layer
            var layer = CAShapeLayer()
            layer.frame = self.bounds
            layer.backgroundColor = UIColor.clear.cgColor
            // if instanceShape exists, copy its properties over to the new layer
            let big = index == 0 || index == 17 || index == 34 || index == 51
            if big {
                layer.strokeColor = instanceShapeBig.strokeColor
                layer.opacity = instanceShapeBig.opacity
                layer.lineWidth = instanceShapeBig.lineWidth
                layer.lineCap = instanceShapeBig.lineCap
                layer.path = instanceShapeBig.path
            } else {
                // otherwise, set the layer's properties to some reasonable defaults
                layer.strokeColor = instanceShape.strokeColor
                layer.opacity = instanceShape.opacity
                layer.lineWidth = instanceShape.lineWidth
                layer.lineCap = instanceShape.lineCap
                layer.path = instanceShape.path

            }
            // 4. Apply a rotation transform to the layer, based on our calculated angle
            layer.transform = CATransform3DMakeRotation(CGFloat(Float(index) * angle), 0.0, 0.0, 1.0)
            // 5. Store a reference to the layer in our instanceLayers array...
            instanceLayers.append(layer)
            // 6. And, finally, add the shape layer to self
            print(index)
            self.addSublayer(layer)
        }
    }
    
}


extension UIColor{
    convenience init(hex: UInt, alpha: CGFloat) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
    
    static var mainPink: UIColor {
        return UIColor(hex: 0xFFA5A9, alpha: 1)
    }
}
