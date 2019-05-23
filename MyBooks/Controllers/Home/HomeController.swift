//
//  HomeController.swift
//  MyBooks
//
//  Created by Ahmad Abduljawad on 21/05/2019.
//  Copyright © 2019 Test. All rights reserved.
//

import UIKit

enum EditMode {
    case idle
    case active
}

enum EntryPoint {
    case appDelegate
    case loginScreen
}

class HomeController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
        }
    }
    
    @IBOutlet weak var editButton: UIButton!

    let databaseHandler = DataBaseHandler.shared
    let userDefaultsHandler = UserDefaultsHandler.shared
    var books = [Book]()
    var editMode: EditMode = .idle
    var entryPoint = EntryPoint.appDelegate
    
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
        
        let bookData = BookData(title: nil, oldISBN: nil, newISBN: nil, cover: nil, releaseDate: nil, notifiyRelease: false)
        navigateToAddEditController(OperationType.add, bookData)
    }
    
    @IBAction func logoutButtonAction(_ sender: Any) {
        
        // remove user credentials
        userDefaultsHandler.setUserEmail(nil)
        
        guard entryPoint == .loginScreen else {
            present(instantiate(LoginController.self, storyboard: .Main))
            return
        }
        // unwind to login screen.
        performSegue(withIdentifier: Constants.StoryBoardKeys.unwindToLogin, sender: nil)
    }
    
}

extension HomeController {
    
    func preSettings() {
        
        checkoutNotificationsStatus()
        fetchUserBooks()
        setupCollectionView()
        //addBooksForUser("a@a.co")
    }
    
    func fetchUserBooks() {
        
        do {
            books = try databaseHandler.retrieveBooksForCurrentUser()
        } catch let error as NSError {
            self.showMessage(title: "⚠️", msg: error.localizedDescription)
        }
    }
    
    func setupCollectionView() {
        
        collectionView.registerNib(className: HomeItemCell.self)
    }
    
    func navigateToAddEditController(_ operationType: OperationType, _ bookData: BookData) {
        
        let addEditController = instantiate(AddEditController.self, storyboard: .Main)
        addEditController.operationType = operationType
        addEditController.bookData = bookData
        addEditController.booksTrackerDelegate = self
        push(viewController: addEditController)
    }
}


