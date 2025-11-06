//
//  Utils.swift
//  mood_capture
//
//  Created by MacBook on 06/11/24.
//

import Foundation
import UIKit
struct Utils{
  
    static func isValidEmail(data: String) -> Bool {
        let emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: data)
    }
    
   
}
