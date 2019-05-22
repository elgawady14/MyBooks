//
//  HomeController.swift
//  MyBooks
//
//  Created by Ahmad Abduljawad on 21/05/2019.
//  Copyright © 2019 Test. All rights reserved.
//

import UIKit
import UserNotifications

enum EditMode {
    case idle
    case active
}

class HomeController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
        }
    }
    
    @IBOutlet weak var editButton: UIButton!
    //    let imgs = ["img1", "img2", "img3", "img4", "img5", "img6", "img7"]
//    let titles = ["img1", "img2", "img3", "img4", "img5", "img6", "img7"]

    let databaseHandler = DataBaseHandler.shared
    let userDefaultsHandler = UserDefaultsHandler.shared
    var books = [Book]()
    var editMode: EditMode = .idle

    override func viewDidLoad() {
        super.viewDidLoad()
        preSettings()
    }
    
    
    @IBAction func editButtonAction(_ sender: Any) {
        
        editMode = editMode == .idle ? .active : .idle
        editButton.setTitle(editMode == .idle ? "Edit" : "Done", for: .normal)
        collectionView.reloadData()
    }
    
    @IBAction func addButtonAction(_ sender: Any) {
        navigateToAddEditController(OperationType.add)
        //showLocalNotification("A new book 📖  has been 📕 released!", "Arab History book just released.")
    }
}

extension HomeController {
    
    func preSettings() {
        
        checkoutNotificationsStatus()
        books = databaseHandler.retrieveBooksForCurrentUser()
        setupCollectionView()
        //addBooksForUser("a@a.co")
    }
    
    func setupCollectionView() {
        
        collectionView.registerNib(className: HomeItemCell.self)
    }
    
    func navigateToAddEditController(_ operationType: OperationType, _ selectedBook: Book? = nil) {
        
        let addEditController = instantiate(AddEditController.self, storyboard: .Main)
        addEditController.operationType = operationType
        addEditController.selectedBook = selectedBook
        push(viewController: addEditController)
    }
}

extension HomeController: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert, .sound])
    }
}

