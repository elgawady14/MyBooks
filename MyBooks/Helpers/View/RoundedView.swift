//
//  RoundedView.swift
//  MyBooks
//
//  Created by Ahmad Abduljawad on 3/26/18.
//  Copyright © 2018 MyBooks. All rights reserved.
//

import UIKit

typealias MyBooksView = RoundedView
@IBDesignable
class RoundedView: UIView {
    
    @IBInspectable var allCorners:   Bool = true   { didSet { configure() } }
    @IBInspectable var topLeft:      Bool = false   { didSet { configure() } }
    @IBInspectable var topRight:     Bool = false   { didSet { configure() } }
    @IBInspectable var bottomLeft:   Bool = false   { didSet { configure() } }
    @IBInspectable var bottomRight:  Bool = false   { didSet { configure() } }
    @IBInspectable var corderRadius: CGFloat = 10.0 { didSet { configure() } }
    @IBInspectable var borderWidth:  CGFloat = 0.0  { didSet { configure() } }
    @IBInspectable var borderColor:  UIColor = .lightGray { didSet { configure() } }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        configure()
    }
    
    var corners: UIRectCorner {
        get {
            if allCorners { return .allCorners }
            var tmp: UIRectCorner = []
            if topLeft { tmp.insert(.topLeft) }
            if topRight { tmp.insert(.topRight) }
            if bottomLeft { tmp.insert(.bottomLeft) }
            if bottomRight { tmp.insert(.bottomRight) }
            return tmp
        }
    }
}

extension MyBooksView: Roundable {
    
    func configure() {
        
        let borderPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: corderRadius, height: corderRadius)).cgPath
        let cardMaskLayer = CAShapeLayer()
        cardMaskLayer.borderWidth = borderWidth
        cardMaskLayer.path = borderPath
        cardMaskLayer.frame = self.bounds
        cardMaskLayer.borderColor = borderColor.cgColor
        cardMaskLayer.masksToBounds = true
        layer.mask = cardMaskLayer
        layer.shadowPath = borderPath
    }
}
