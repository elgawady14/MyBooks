//
//  ViewControllerExtensions.swift
//  MyBooks
//
//  Created by Ahmad Abduljawad on 3/27/18.
//  Copyright © 2018 MyBooks. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

extension UIViewController: StoryboardIdentifiable {

    func instantiate<T: UIViewController>(_ viewController: T.Type, storyboard appStoryboard: UIStoryboard.StoryboardEnumerated) -> T {
        return appStoryboard.instantiateViewController(viewControllerClass: viewController)
    }

    func present(_ viewController: UIViewController.Type,storyboard appStoryboard: UIStoryboard.StoryboardEnumerated) {
        let viewController = appStoryboard.instantiateViewController(viewControllerClass: viewController)
        present(viewController)
    }

    func presentWithNavigationBar(_ viewController: UIViewController.Type,storyboard appStoryboard: UIStoryboard.StoryboardEnumerated) {
        let rootViewController = appStoryboard.instantiateViewController(viewControllerClass: viewController)
        let navigationViewController = UINavigationController(rootViewController: rootViewController)
        present(navigationViewController)
    }

    func presentWithNavigationBar(_ viewController: UIViewController) {
        let navigationViewController = UINavigationController(rootViewController: viewController)
        present(navigationViewController)
    }

    func present(_ viewController: UIViewController) {
        present(viewController, animated: true) {}
    }
}


extension UIViewController {
    
    func showOneActionAlert(title: String?, msg: String?, btnTitle: String?, btnHandler: (() -> ())?) {
        guard let _ = btnTitle else { return }
        guard title != nil || msg != nil else { return }
        let alert = UIAlertController(title: title ?? "", message: msg ?? "", preferredStyle: .alert)
        let action1 = UIAlertAction(title: btnTitle!, style: .default) { _ in
            btnHandler?()
        }
        alert.addAction(action1)
        present(alert, animated: true, completion: nil)
    }
    
    func showTwoActionsAlert(title: String?, msg: String?, btn1Title: String?, btn2Title: String?, btn1Handler: (() -> ())?) {
        guard let _ = btn1Title, let _ = btn2Title else { return }
        guard title != nil || msg != nil else { return }
        let alert = UIAlertController(title: title ?? "", message: msg ?? "", preferredStyle: .alert)
        let action1 = UIAlertAction(title: btn1Title!, style: .destructive) { _ in
            btn1Handler?()
        }
        let action2 = UIAlertAction(title: btn2Title!, style: .default)
        alert.addAction(action1)
        alert.addAction(action2)
        present(alert, animated: true, completion: nil)
    }
}

extension UISearchBar {
    enum MyBarStyle {
        case AddAddressMapView
    }
    
    func setBar(_ style: MyBarStyle) {
        switch style {
        case .AddAddressMapView:
            showsCancelButton = false
            tintColor = .brown
            searchBarStyle  = .minimal
            backgroundColor = .white
            barTintColor = .brown
            keyboardAppearance = .dark
            returnKeyType = .done
        }
    }
    
}

extension UIViewController {
    
    var userDefaults: UserDefaults {
        return UserDefaults.standard
    }
    
    func showMessage(title: String?, msg: String?) {
        
        let av = UIAlertController(title: title ?? "", message: msg ?? "", preferredStyle: .alert)
        let action = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default, handler: nil)
        
        av.addAction(action)
        self.present(av, animated: true, completion: nil)
    }
    
    func showMessage(msg: String?) {
        
        let av = UIAlertController(title: "Info", message: msg ?? "", preferredStyle: .alert)
        let action = UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default, handler: nil)
        
        av.addAction(action)
        self.present(av, animated: true, completion: nil)
    }
    
    func pop(animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }
    
    func push(viewController: UIViewController, animated: Bool = true) {
        navigationController?.pushViewController(viewController, animated: animated)
    }
    
    func present<T: UIViewController>(vc: T.Type) {
        guard let dest = self.storyboard?.instantiateViewController(withIdentifier: String(describing: vc)) as? T else { return }
        present(dest, animated: true, completion: nil)
    }
}


extension UIViewController {
    
    func scheduleLocalNotification(title: String, body: String, date: Date) {
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.badge = 1
        content.sound = .default
        let triggerWeekly = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerWeekly, repeats: false)
        trigger.nextTriggerDate()
        
        let requestIdentifier = "MyBooksNotification"
        let request = UNNotificationRequest(identifier: requestIdentifier,
                                            content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request,
                                               withCompletionHandler: { (error) in
                                                // Handle error
        })
    }
}

extension UIViewController {
    
    func checkoutNotificationsStatus() {
        
        UNUserNotificationCenter.current().requestAuthorization(options:
            [[.alert, .sound, .badge]], completionHandler: { (granted, error) in })
        UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }
}
