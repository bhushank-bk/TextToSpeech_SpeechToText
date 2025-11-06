//
//  loaderExtension.swift
//  mood_capture
//
//  Created by MacBook on 30/10/24.
//

import Foundation
import UIKit

extension UIViewController {
    func showLoader() {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = self.view.center
        activityIndicator.startAnimating()
        activityIndicator.tag = 100 // Tag to identify it later for removal
        self.view.addSubview(activityIndicator)
    }
    
    func hideLoader() {
        if let loader = self.view.viewWithTag(100) as? UIActivityIndicatorView {
            loader.stopAnimating()
            loader.removeFromSuperview()
        }
    }
    
    func showToast(message: String, duration: Double = 5.0) {
           let toastLabel = UILabel()
           toastLabel.text = message
           toastLabel.textColor = .white
           toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
           toastLabel.textAlignment = .center
           toastLabel.font = UIFont.systemFont(ofSize: 14)
           toastLabel.alpha = 1.0
           toastLabel.layer.cornerRadius = 10
           toastLabel.clipsToBounds = true

           // Set label frame and position
           let textSize = toastLabel.intrinsicContentSize
           let padding: CGFloat = 16
           toastLabel.frame = CGRect(x: (self.view.frame.size.width - textSize.width) / 2 - padding,
                                     y: self.view.frame.size.height - 100,
                                     width: textSize.width + 2 * padding,
                                     height: textSize.height + padding)

           // Add the label to the view controller's view
           self.view.addSubview(toastLabel)

           // Animation for showing and hiding the toast
           UIView.animate(withDuration: duration, delay: 0.1, options: .curveEaseOut, animations: {
               toastLabel.alpha = 0.0
           }) { _ in
               toastLabel.removeFromSuperview()
           }
       }
    
    func revealViewController() -> TabBarViewController? {
            var viewController: UIViewController? = self
            
            if viewController != nil && viewController is TabBarViewController {
                return viewController! as? TabBarViewController
            }
            while (!(viewController is TabBarViewController) && viewController?.parent != nil) {
                viewController = viewController?.parent
            }
            if viewController is TabBarViewController {
                return viewController as? TabBarViewController
            }
            return nil
        }
    
}
