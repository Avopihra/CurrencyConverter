//
//  AnimationManager.swift
//  CurrencyConverter
//
//  Created by Viktoriya on 30.05.2023.
//

import UIKit

final class AnimationManager {
    
    static func animate(duration: TimeInterval = 0.3,
                        options: UIView.AnimationOptions = .curveLinear,
                        block: @escaping () -> (),
                        completion: ((Bool) -> ())? = nil) {
        UIView.animate(withDuration: duration,
                       delay: 0,
                       options: options,
                       animations: block,
                       completion: completion)
    }
    
    static func shake(_ T: AnyObject) {
        
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: T.center.x - 10, y: T.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: T.center.x + 10, y: T.center.y))
        
        T.layer.add(animation, forKey: "position")
        T.layer.borderColor = UIColor.red.cgColor
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            T.layer.borderColor = UIColor.grayBorder.cgColor
        }
    }
}
