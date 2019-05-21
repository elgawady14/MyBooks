//
//  NSObjectExtensions.swift
//  MyBooks
//
//  Created by Ahmad Abduljawad on 4/5/18.
//  Copyright © 2018 MyBooks. All rights reserved.
//

import Foundation
import UIKit

extension NSObject {
    
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    var mainStoryboard: UIStoryboard {
        return UIStoryboard(name: Constants.StoryBoardKeys.Main, bundle: Bundle.main)
    }
    
    func animation(_ duration: TimeInterval, _ delay: TimeInterval, _ options: UIView.AnimationOptions, _ animations: @escaping ()->(), _ completion: ((Bool)->Void)? = nil) {
        
        UIView.animate(withDuration: duration, delay: delay, options: options, animations: {
            animations()
        }) { success in
            guard let _ = completion else { return }
            completion!(success)
        }
    }
    
    func iphoneX() -> Bool {
        if UIDevice.current.userInterfaceIdiom == .phone && UIScreen.main.bounds.size.height >= 812.0 {
            return true
        } else {
            return false
        }
    }
    
    func iphone4Or5OrSE() -> Bool {
        if UIDevice.current.userInterfaceIdiom == .phone && UIScreen.main.bounds.size.height <= 568.0 {
            return true
        } else {
            return false
        }
    }
    
    func statusBarHeight() -> CGFloat {
        let frame = UIApplication.shared.statusBarFrame
        return frame.size.height
    }
    
    func topPaddingIphoneX() -> CGFloat {
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.delegate!.window!
            return window!.safeAreaInsets.top
        } else {
            return CGFloat(44.0)
        }
    }
    
    func bottomPaddingIphoneX() -> CGFloat {
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.delegate!.window!
            return window!.safeAreaInsets.bottom
        } else {
            return CGFloat(34.0)
        }
    }
    
    var gcdQueueName: String { return Bundle.main.bundleIdentifier! + NSStringFromClass(self.classForCoder) }
    
    func runThisInMainThread(block: @escaping ()->()) {
        let queue = DispatchQueue.main
        queue.async {
            block()
        }
    }
    
    func isDebugMode() -> Bool {
        
        let mode =  Bundle.main.object(forInfoDictionaryKey: "MODE") as! String
        if mode == "DEBUG" {
            return true
        }
        return false
    }
    
    func runInQueue(name: String, type: DispatchQoS, _ block: @escaping ()->()) {
        let queue = DispatchQueue(label: name, qos: type)
        queue.async {
            block()
        }
    }
    
    func runInBackgroundQueue(name: String, _ block: @escaping ()->()) {
        let queue = DispatchQueue(label: name, qos: DispatchQoS.background)
        queue.async {
            block()
        }
    }
    
    func delay(_ time: Double, block: @escaping ()->()) {
        let queue = DispatchQueue.main
        queue.asyncAfter(deadline: .now() + time) {
            block()
        }
    }
}

extension AppDelegate {
    class func getDocumentsDirectory() {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        print("Documents path :: \(documentsDirectory)")
    }
}
