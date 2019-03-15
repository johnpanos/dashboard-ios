//
//  UIFieldView.swift
//  Dashboard
//
//  Created by John Panos on 3/14/19.
//  Copyright © 2019 John Panos. All rights reserved.
//

import Foundation
import UIKit

class UIFieldView: UIImageView {
    var pixelRatio: CGFloat?
    var uiPoints: [UIView] = [UIView]()
    var bezierPathShape: CAShapeLayer?
    
    override init(image: UIImage?) {
        // Init ImageView
        super.init(image: image)
        self.pixelRatio = self.frame.height / self.image!.size.height
        self.layer.masksToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.pixelRatio = self.frame.height / self.image!.size.height
    }
    
    func play(points: [FieldPoint], origin: FieldPoint, drawPath: Bool) {
        self.reset()
        self.drawPoints(points: points, origin: origin, closure: {
            if drawPath {
                self.bezierPathShape = CAShapeLayer()
                self.bezierPathShape?.path = self.createBezierForPath(points: points, origin: origin).cgPath
                
                // apply other properties related to the path
                self.bezierPathShape?.strokeColor = UIColor.red.cgColor
                self.bezierPathShape?.fillColor = UIColor.clear.cgColor
                self.bezierPathShape?.lineWidth = 2.0
                self.bezierPathShape?.position = CGPoint(x: 0, y: 0)
                
                let animation = CABasicAnimation(keyPath: "strokeEnd")
                animation.duration = 2.0
                animation.fromValue = 0.0
                animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                self.bezierPathShape?.add(animation, forKey: nil)
                // add the new layer to our custom view
                self.layer.addSublayer(self.bezierPathShape!)
            }
        })
    }
    
    func reset() {
        self.clearPoints()
        self.clearBezierPath()
    }
    
    func clearPoints() {
        for i in 0..<self.uiPoints.count {
            self.uiPoints[i].removeFromSuperview()
        }
    }
    
    func clearBezierPath() {
        self.bezierPathShape?.removeFromSuperlayer()
    }
    
    func pixelToScaledPixel(_ x: CGFloat) -> CGFloat {
        return pixelRatio! * x
    }
    
    func inchesToScaledXPixel(_ x: CGFloat) -> CGFloat {
        return (x * (1155.0/(54.0 * 12)) + 217) * pixelRatio!
    }
    
    func inchesToScaledYPixel(_ x: CGFloat) -> CGFloat {
        return (x * (575.0/(27.0 * 12)) + 40) * pixelRatio!
    }
    
    func createPointForCoordInches(x: CGFloat, y: CGFloat, scaleFactor: CGFloat) -> UIView {
        let xRatio: CGFloat = (1155.0/(54.0 * 12))
        let yRatio: CGFloat = (575.0/(27.0 * 12))
        return createPointForCoord(x: (x * xRatio) + 217, y: (y * yRatio) + 40, scaleFactor: scaleFactor)
    }
    
    func createPointForCoord(x: CGFloat, y: CGFloat, scaleFactor: CGFloat) -> UIView {
        let point = UIView()
        point.backgroundColor = UIColor.red
        point.layer.cornerRadius = 5
        point.layer.masksToBounds = true
        point.frame = CGRect(x: x * pixelRatio! - 5, y: y * pixelRatio! - 5, width: 10, height: 10);
        return point
    }
    
    func createBezierForPath(points: [FieldPoint], origin: FieldPoint) -> UIBezierPath {
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: inchesToScaledXPixel(origin.x), y: inchesToScaledYPixel(origin.y)))
        
        for i in 0..<points.count {
            let point = convertToRobotReference(point: points[i], origin: origin)
            path.addLine(to: CGPoint(x: inchesToScaledXPixel(point.x), y: inchesToScaledYPixel(point.y)))
        }
        
        return path
    }
    
    private func drawPoints(points: [FieldPoint], origin: FieldPoint, closure: @escaping () -> Void) {
        self.pixelRatio = self.frame.height / self.image!.size.height
        for i in 0..<points.count {
            let point = convertToRobotReference(point: points[i], origin: origin)
            let uiPoint = createPointForCoordInches(x: point.x, y: point.y, scaleFactor: pixelRatio!)
            uiPoint.backgroundColor = UIColor(displayP3Red: 0, green: (1.0/CGFloat(points.count)) * CGFloat(i), blue: 0, alpha: 1)
            uiPoint.alpha = 0.0
            self.addSubview(uiPoint)
            self.uiPoints.append(uiPoint)
            UIView.animate(withDuration: 0.5, delay: 0.5 + (Double(i) * 0.10), usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: {
                uiPoint.alpha = 1
            }, completion: { _ in
                if i == points.count - 1 {
                    closure()
                }
            })
        }
    }
    
    // Rotate point around origin
    func rotatePoint(target: FieldPoint, aroundOrigin origin: FieldPoint, byDegrees: CGFloat) -> FieldPoint {
        let dx = target.x - origin.x
        let dy = target.y - origin.y
        let radius = sqrt(dx * dx + dy * dy)
        let azimuth = atan2(dy, dx) // in radians
        let newAzimuth = azimuth + byDegrees * CGFloat(.pi / 180.0) // convert it to radians
        let x = origin.x + radius * cos(newAzimuth)
        let y = origin.y + radius * sin(newAzimuth)
        return FieldPoint(x: x, y: y)
    }
    
    // Convert to pure pursuit coordinate system, moves to origin on the field
    // then reflects the x axis and rotates the point 90 degrees around origin
    private func convertToRobotReference(point: FieldPoint, origin: FieldPoint) -> FieldPoint {
        var inputPoint = point
        inputPoint.x *= -1
        inputPoint.x += origin.x
        inputPoint.y += origin.y
        return rotatePoint(target: inputPoint, aroundOrigin: origin, byDegrees: -90)
    }
}
