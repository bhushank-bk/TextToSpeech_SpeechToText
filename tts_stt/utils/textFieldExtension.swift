//
//  textFieldExtension.swift
//  mood_capture
//
//  Created by MacBook on 06/11/24.
//

import Foundation
import UIKit

extension UITextField {
    
    func animateRedBorderIfEmpty() {
        guard self.text?.isEmpty ?? true else {
            // Reset border color and animation if there's text
            self.layer.borderColor = UIColor.clear.cgColor
            self.layer.borderWidth = 0
            self.layer.removeAllAnimations()
            return
        }
        
        // Add red border and animation if field is empty
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.red.cgColor
        let animation = CABasicAnimation(keyPath: "borderColor")
        animation.fromValue = UIColor.clear.cgColor
        animation.toValue = UIColor.red.cgColor
        animation.duration = 0.5
        animation.autoreverses = true
        animation.repeatCount = .infinity
        self.layer.add(animation, forKey: "borderColor")
    }
}
