//
//  UIViewExtensions.swift
//  MyBooks
//
//  Created by Ahmad Abduljawad on 3/28/18.
//  Copyright © 2018 MyBooks. All rights reserved.
//

import UIKit

extension UIColor {
    
    class var mainColor: UIColor {
        return UIColor(red: 148.0/255.0, green: 23.0/255.0, blue: 81.0/255.0, alpha: 1.0)
    }
    
    class var turquoiseBlue: UIColor {
        return UIColor(red: 7.0/255.0, green: 174.0/255.0, blue: 204.0/255.0, alpha: 1.0)
    }
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0)
    }
    
}

extension UIColor {
    convenience init(r: Int, g: Int, b: Int, alpha: Int) {
        self.init(red: CGFloat(r/255), green: CGFloat(g/255), blue: CGFloat(b/255), alpha: CGFloat(alpha))
    }
    
    convenience init(opacity: Double) {
        self.init(white: 0, alpha: CGFloat(opacity))
    }
}
