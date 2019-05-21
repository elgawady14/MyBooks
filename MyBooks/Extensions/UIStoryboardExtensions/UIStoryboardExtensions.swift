//
//  UIStoryboardExtensions.swift
//  MyBooks
//
//  Created by Ahmad Abduljawad on 3/27/18.
//  Copyright © 2018 MyBooks. All rights reserved.
//
import Foundation
import UIKit

extension UIStoryboard {
    
    enum StoryboardEnumerated: String {
        case Prelogin
        case Main
        case SideMenu
        
        var filename: String {
            return rawValue
        }
        
        var instance : UIStoryboard {
            return UIStoryboard(name: filename, bundle: Bundle.main)
        }
        
        // MARK: - View Controller Instantiation from Generics
        func instantiateViewController<T: UIViewController>(viewControllerClass : T.Type) -> T {
            guard let viewController = instance.instantiateViewController(withIdentifier: viewControllerClass.storyboardIdentifier) as? T else {
                fatalError("Couldn't instantiate view controller with identifier \(viewControllerClass.storyboardIdentifier) ")
            }
            
            return viewController
        }
    }
}

protocol StoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
}

extension StoryboardIdentifiable {
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
}
