//
//  AnimationManager.swift
//  CurrencyConverter
//
//  Created by Viktoriya on 30.05.2023.
//

import UIKit

final class AnimationManager {
    
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
            T.layer.borderColor = UIColor.black.cgColor
        }
    }
}
