//
//  LoadingView.swift
//  testLoading
//
//  Created by Nicky on 7/3/17.
//  Copyright © 2017 Nicky. All rights reserved.
//

import Foundation
import UIKit

class LoadingView: UIView {
    fileprivate var progressBarIndicator: UIView!
    fileprivate var screenSize: CGRect = UIScreen.main.bounds
    var isAnimationRunning = false
    var height : CGFloat = 2
    var intialWidth : CGFloat = 10
    var theSuperView: UIView?
    public init(){
        if LoadingView.iphoneX() {
            super.init(frame: CGRect(x: 0, y: LoadingView.topPaddingIphoneX() + 44, width: screenSize.width, height: 0))
        } else {
            super.init(frame: CGRect(x: 0, y: 64, width: screenSize.width, height: 0))
        }
         self.progressBarIndicator = UIView(frame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 0, height: height)))
    }
    
    public convenience init (yOrigin: CGFloat, theSuperView: UIView) {
        self.init()
        self.theSuperView = theSuperView
        self.frame = CGRect(x: 0, y: yOrigin, width: screenSize.width, height: 0)
        self.progressBarIndicator = UIView(frame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 0, height: height)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        //progressBarIndicator.createGradientLayer()

        screenSize = UIScreen.main.bounds
        
        if (UIDevice.current.orientation.isPortrait) {
             self.frame = CGRect(origin: CGPoint(x: self.frame.origin.x,y :self.frame.origin.y), size: CGSize(width: screenSize.width, height: self.frame.height))
        }
        if (UIDevice.current.orientation.isLandscape) {
           self.frame = CGRect(origin: CGPoint(x: self.frame.origin.x,y :self.frame.origin.y), size: CGSize(width: screenSize.width, height: self.frame.height))
        }
    }

    open func startAnimating() {
        
        self.backgroundColor = .clear
        self.progressBarIndicator.backgroundColor = .mainColor
        self.layoutIfNeeded()
    
        show()

        if !isAnimationRunning {
            self.isAnimationRunning = true
            
            UIView.animate(withDuration: 0.5, delay:0, options: [], animations: {
                self.frame = CGRect(x: 0, y: self.frame.origin.y, width: self.screenSize.width, height: self.height)
            }, completion: { animationFinished in
                self.addSubview(self.progressBarIndicator)
                self.configureAnimation()
            })
        }
    }
    
    open func stopAnimating(){
        isAnimationRunning = false
        delay(0.5) {
            UIView.animate(withDuration: 0.5, animations: {
                self.progressBarIndicator.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
                self.frame = CGRect(x: 0, y: self.frame.origin.y, width: 0, height: 0)
            })
        }
    }
    
   fileprivate func show() {
        
        // Only show once
        if self.superview != nil {
            return
        }
    
        if let _ = theSuperView {
            theSuperView!.addSubview(self)
        } else {
            // Find current top viewcontroller
            if let topController = getTopViewController() {
                let superView: UIView = topController.view
                superView.addSubview(self)
            }
        }
    }
    
    fileprivate func configureAnimation() {
        
        guard let superview = self.superview else {
            stopAnimating()
            return
        }
        
        self.progressBarIndicator.frame = CGRect(origin: CGPoint(x: 0, y :0), size: CGSize(width: intialWidth, height: height))
        
        UIView.animateKeyframes(withDuration: 1.0, delay: 0, options: [.repeat,.autoreverse], animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                self.progressBarIndicator.frame = CGRect(x: superview.frame.width/2-self.intialWidth*6, y: 0, width: self.intialWidth*6, height: self.height)
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                self.progressBarIndicator.frame = CGRect(x: superview.frame.width-self.intialWidth, y: 0, width: self.intialWidth, height: self.height)
                
            })
            
            
        }) { (completed) in
            if (self.isAnimationRunning){
                self.configureAnimation()
            }
        }
    }
    
    
    fileprivate func getTopViewController() -> UIViewController? {
        var topController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
        while topController?.presentedViewController != nil {
            topController = topController?.presentedViewController
        }
        return topController
    }
    
}

extension LoadingView {
    class func iphoneX() -> Bool {
        if UIDevice.current.userInterfaceIdiom == .phone && UIScreen.main.bounds.size.height >= 812.0 {
            return true
        } else {
            return false
        }
    }
    
    class func topPaddingIphoneX() -> CGFloat {
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            return window!.safeAreaInsets.top
        } else {
            return CGFloat(44.0)
        }
    }
}

