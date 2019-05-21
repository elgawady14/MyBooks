//
//  UIViewExtensions.swift
//  MyBooks
//
//  Created by Ahmad Abduljawad on 3/28/18.
//  Copyright © 2018 MyBooks. All rights reserved.
//

import Foundation
import UIKit

enum RoundedCorners: Int {
    case on = 0
    case off
}

enum AnimationDirection: Int {
    case positive = 1
    case negative = -1
}

extension UIView {
    
    func transition(_ duration: TimeInterval, _ options: UIView.AnimationOptions, _ animations: @escaping ()->(), _ completion: ((Bool)->Void)?) {
        UIView.transition(with: self, duration: duration, options: options, animations: {
            animations()
        }) { success in
            guard let _ = completion else { return }
            completion!(success)
        }
    }

    
    class PassThroughView: UIView {
        override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
            let view = super.hitTest(point, with: event)
            return view == self ? nil : view
        }
    }
    
    func toast(text: String, duration: TimeInterval, position: CGPoint) {
        //makeToast(text, duration: duration, point: position, title: nil, image: nil)
    }
    
    func roundCorners(withRadius radius: Float, withBorder border: Float)
    {
        self.layer.cornerRadius = CGFloat(radius)
        self.layer.masksToBounds = true
        self.layer.borderWidth = CGFloat(border)
        self.layer.borderColor = UIColor.gray.cgColor
    }
    
    func disableView() {
        self.isUserInteractionEnabled = false
        self.alpha = CGFloat(0.5)
    }
}

extension UIButton {
    func setHighLightColor(_ highlightColor: UIColor, originalColor: UIColor) {
        if isHighlighted {
            //backgroundColor = .highlightColor
        } else {
            backgroundColor = originalColor
        }
    }
}

