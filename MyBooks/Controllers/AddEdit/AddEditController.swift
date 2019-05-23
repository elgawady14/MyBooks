//
//  AddEditController.swift
//  MyBooks
//
//  Created by Ahmad Abduljawad on 21/05/2019.
//  Copyright © 2019 Test. All rights reserved.
//

import UIKit

enum OperationType {
    case add
    case edit
}

protocol BooksTracker {
    func AddController(didAddNewBook book: Book)
    func EditController(didUpdateBook book: Book)
}
class AddEditController: UIViewController {

    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var coverImgView: UIImageView! {
        didSet {
            coverImgView.layer.cornerRadius = 10
            coverImgView.layer.borderWidth = 0.5
            coverImgView.layer.borderColor = UIColor.black.cgColor
            coverImgView.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var titleTF: UITextField! {
        didSet {
            titleTF.delegate = self
        }
    }
    @IBOutlet weak var isbnTF: UITextField! {
        didSet {
            isbnTF.delegate = self
        }
    }
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var releaseNotifierSwitch: UISwitch!
    let databaseHandler = DataBaseHandler.shared
    let userDefaultsHandler = UserDefaultsHandler.shared
    var operationType = OperationType.add
    var bookData: BookData!
    var booksTrackerDelegate: BooksTracker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        preSettings()
    }
    
    @IBAction func uploadButtonAction(_ sender: UIButton) {
        presentUploadOptionsAlert(sender)
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        
        // set data
        bookData.title = titleTF.text
        bookData.newISBN = isbnTF.text
        bookData.releaseDate = datePicker.date
        bookData.notifiyRelease = releaseNotifierSwitch.isOn

        guard isDataValid() else {
            showMessage(title: "⚠️", msg: "All fields are required!")
            return
        }
        
        switch operationType {
        case .add:
            
            do {
                let book = try databaseHandler.insertNewBookForCurrentUser(isbn: bookData.newISBN!, title: bookData.title!, cover: bookData.cover!, releaseDate: bookData.releaseDate!, releaseNotify: bookData.notifiyRelease!)
                booksTrackerDelegate.AddController(didAddNewBook: book)
            } catch let error {
                showMessage(title: "⚠️", msg: error.localizedDescription)
            }
            
        case .edit:
            
            do {
                let book = try databaseHandler.updateBookForCurrentUser(oldISBN: bookData.oldISBN!, newISBN: bookData.newISBN!, title: bookData.title!, cover: bookData.cover!, releaseDate: bookData.releaseDate!, releaseNotify: bookData.notifiyRelease!)
                booksTrackerDelegate.EditController(didUpdateBook: book)

            } catch let error {
                showMessage(title: "⚠️", msg: error.localizedDescription)
            }
        }
    }
}


extension AddEditController {
    
    func preSettings() {
        setUI()
    }
    
    fileprivate func setUI() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKB))
        contentView.addGestureRecognizer(tapGesture)
        navigationItem.title = operationType == .add ? "New Book" : "\(bookData.title ?? "Update Book")"
        navigationController?.navigationBar.tintColor = .black

        switch operationType {

        case .edit:
            coverImgView.image = UIImage(data: bookData.cover!)
            titleTF.text = bookData.title
            isbnTF.text = bookData.newISBN
            datePicker.date = bookData.releaseDate!
            releaseNotifierSwitch.isOn = bookData.notifiyRelease!

        default: break
        }
    }
    
    func isDataValid() -> Bool {
        
        guard let _ = bookData.cover, !String.isFadi(bookData.title), !String.isFadi(bookData.newISBN), let _ = bookData.releaseDate, let _ = bookData.notifiyRelease else {
            return false
        }
        return true
    }
}

extension AddEditController {
    
    @objc func dismissKB() {
        view.endEditing(true)
    }
}
