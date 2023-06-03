//
//  TouchableButton.swift
//  CurrencyConverter
//
//  Created by Viktoriya on 03.06.2023.
//

import UIKit

//MARK: - Custom Animation Button Class

class TouchableButton: UIButton {
    
    private(set) var tapAnimationDuration: Double = 0.3
    private var eventOccuredTime: TimeInterval?
    private var eventDurationTime: TimeInterval = 0

    private var needVibrationForLongTap = true
    var needVibrations: Bool = true
    var transformValue: CGFloat = 0.95
    
    var touchesBeganAction: (()->Void)?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        eventOccuredTime = event?.timestamp
        tapAnimation()
        touchesBeganAction?()
    }

    var touchesEndedAction: (()->Void)?
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        touchEnded(with: event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        touchEnded(with: event)
    }
}

private extension TouchableButton {
    func updateNeedVibrationForLongTap(touchEndedEvent: UIEvent?) {
        if let touchEndedTime = touchEndedEvent?.timestamp,
           let touchStartedTime = eventOccuredTime {
            let eventDurationTime = touchEndedTime - touchStartedTime
            needVibrationForLongTap = (eventDurationTime > tapAnimationDuration)
        }
    }
    
    func touchEnded(with event: UIEvent?) {
        updateNeedVibrationForLongTap(touchEndedEvent: event)
        if !needVibrationForLongTap {
            makeVibration()
        }
        untapAnimation()
        touchesEndedAction?()
    }
    
    func tapAnimation() {
        AnimationManager.animate(duration: tapAnimationDuration) {
            self.transform = CGAffineTransform(scaleX: self.transformValue,
                                               y: self.transformValue)
        } completion: { _ in
            guard self.needVibrations,
                  self.needVibrationForLongTap else {
                      return
                  }
            self.makeVibration()
        }
    }
    
    func untapAnimation() {
        AnimationManager.animate(duration: tapAnimationDuration) {
            self.transform = .identity
        }
    }
    
    func makeVibration() {
        HapticManager.feedback(.light)
    }
}
