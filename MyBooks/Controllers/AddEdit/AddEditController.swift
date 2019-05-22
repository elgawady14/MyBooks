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
class AddEditController: UIViewController {

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
    
    var operationType = OperationType.add
    var selectedBook: Book?
    @IBOutlet weak var coverImgView: UIImageView! {
        didSet {
            coverImgView.layer.cornerRadius = 10
            coverImgView.layer.borderWidth = 0.5
            coverImgView.layer.borderColor = UIColor.black.cgColor
            coverImgView.layer.masksToBounds = true
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        preSettings()
    }
}


extension AddEditController {
    
    func preSettings() {
        
        navigationItem.title = operationType == .add ? "New Book" : "\(selectedBook?.title ?? "Update Book")"
        navigationController?.navigationBar.tintColor = .black
    }
}

extension AddEditController {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        titleTF.resignFirstResponder()
        isbnTF.resignFirstResponder()
    }
}
